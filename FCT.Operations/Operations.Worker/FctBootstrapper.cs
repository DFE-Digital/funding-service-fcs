
namespace Operations.Worker
{
    using Audit;
    using DataStore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using NServiceBus.Configuration.AdvancedExtensibility;
    using NServiceBus.MessageMutator;
    using NServiceBus.Persistence.Sql;
    using NServiceBus.Transport.AzureServiceBus;
    using ServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Slack;
    using Storage;
    using System;
    using System.Collections.Generic;
    using Microsoft.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Threading.Tasks;

    public static class FctBootstrapper
    {
        private static ILogger _logger;
        private static ISlackMessageSender _slackMessageSender;

        public static IReadOnlyCollection<IEndpointInstance> Endpoints { get; private set; }

        private static string[] Nsb5Assemblies => new[]
        {
            "CrossDomain.Integration.Common.dll",
            "PaymentManagementDomain.PaymentSchedule.Xrm.Integration.dll"
        };

        public static async Task Start(ILoggerFactory loggerFactory, ILogger currentLogger, IConfigurationRoot appConfiguration)
        {
            _logger = currentLogger;
            _slackMessageSender = new SlackMessageSender(appConfiguration);

            Endpoints = await StartEndpoints(loggerFactory.CreateCoreLogger(), appConfiguration);

            _logger.LogInformation("All endpoints have started");

            if (Convert.ToBoolean(appConfiguration["ShouldMoveAuditMessagesToTable"]))
            {
                _logger.LogInformation("About to start listening for audit messages");

                var configuration = new FcsConfiguration(appConfiguration);

                try
                {
                    await QueueListener.BeginListening(
                        m => FcsMessageProcessor.WriteAuditMessageToTable(m, configuration),
                        "audit",
                        _logger,
                        configuration);
                }
                catch (Exception e)
                {
                    _logger.LogInformation(1, $"Begin Listening has failed: {e.Message}, {e.StackTrace}");
                }

                _logger.LogInformation("Audit Queue Listener started");
            }
        }

        public static async Task Stop()
        {
            _logger.LogInformation("Stopping NServiceBus endpoints");

            foreach (var endpoint in Endpoints)
            {
                await endpoint.Stop().ConfigureAwait(false);
            }
        }

        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(
            ILogger logger,
            IConfigurationRoot appConfiguration)
        {
            _logger.LogInformation("Retrieving Endpoint Configurations");

            string endpointName = null;
            var configuration = new FcsConfiguration(appConfiguration);

            try
            {
                var endpointTypes = new List<Type>
                {
                    typeof(FCT.Operations.FundingAllocationExtract.EndpointConfig),
                    typeof(FCT.Operations.PaymentSummary.EndpointConfig),
                    typeof(FCT.Operations.Cda.ReportGeneration.EndpointConfig),
                    typeof(SFA.FCT.Operations.Integrity.EndpointConfig),
                    typeof(SFA.FCT.Operations.Maintenance.Endpoint.EndpointConfig),
                    typeof(FCT.Operations.Connectivity.EndpointConfig),
                    typeof(FCT.Operations.FundingConfirmationReport.EndpointConfig)
                };

                _logger.LogInformation($"We have found: {endpointTypes.Count} endpoints");

                var endpointConfigurations = endpointTypes.Select(t =>
                {
                    var endpoint = (IEndpointConfigWithFcsConfig)Activator.CreateInstance(t);

                    endpointName = endpoint.EndpointName;

                    _logger.LogInformation(
                        $"Getting configuration for endpoint: {endpoint.EndpointName} - Subscriptions: {endpoint.Subscriptions.Count}");

                    return endpoint.GetBootstrapConfiguration(logger, configuration);
                }).ToList();

                // ✅ FIXED Select issue
                return await Task.WhenAll(endpointConfigurations.Select(ec => Endpoint.Start(ec)));
            }
            catch (Exception e)
            {
                var reflectionException = e as ReflectionTypeLoadException;

                _logger.LogInformation(
                    $"StartEndpoints failed: {endpointName}, {e.Message} - {reflectionException?.LoaderExceptions?.FirstOrDefault()}");

                _logger.LogInformation($"Stacktrace: {e.StackTrace}");

                throw;
            }
        }

        private static EndpointConfiguration GetBootstrapConfiguration(
            this IEndpointConfigWithFcsConfig endpoint,
            ILogger logger,
            IFcsConfiguration appConfiguration)
        {
            var configuration = endpoint.GetEndpointConfiguration(logger, appConfiguration);

            // ✅ Persistence
            var persistence = configuration.UsePersistence<SqlPersistence, StorageType.Sagas>();
            configuration.UsePersistence<SqlPersistence, StorageType.Subscriptions>();

            persistence.SqlDialect<SqlDialect.MsSqlServer>();

            persistence.ConnectionBuilder(() =>
                new SqlConnection(appConfiguration["ConnectionStrings:NServiceBus/Persistence"]));

            // ✅ Assembly scanning
            var scanner = configuration.AssemblyScanner();
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            var referencedAssemblies =
                Assembly.LoadFrom(endpoint.NameOfAssembly)
                    .GetReferencedAssemblies()
                    .Select(a => $"{a.Name}.dll");

            var assembliesToExclude = Directory.EnumerateFiles(baseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .Where(fn =>
                    (fn != endpoint.NameOfAssembly && !referencedAssemblies.Contains(fn))
                    || Nsb5Assemblies.Contains(fn))
                .ToArray();

            scanner.ExcludeAssemblies(assembliesToExclude);

            // ✅ ✅ ✅ TRANSPORT (FINAL FIX)
            var transport = new AzureServiceBusTransport(
                appConfiguration["ConnectionStrings:NServiceBus/Transport"],
                TopicTopology.Default);

            configuration.UseTransport(transport);

            // ✅ Routing

            var routing = configuration.GetSettings()
                .Get<TransportExtensions<AzureServiceBusTransport>>()
                .Routing();

            foreach (var route in endpoint.Routes)
            {
                routing.RouteToEndpoint(route.CommandType, route.Destination);
            }


            // ✅ Serializer
            configuration.UseSerialization<NewtonsoftJsonSerializer>();

            configuration.EnableInstallers();

            configuration.RegisterMessageMutator(
                new TransportMessageCompressionMutator(
                    _logger,
                    new LargeMessageStorageService(((FcsConfiguration)appConfiguration).ConfigurationRoot)));

            configuration.AuditProcessedMessagesTo("audit", TimeSpan.FromDays(7));
            configuration.SendFailedMessagesTo("error");

            // ✅ ✅ ✅ Recoverability FIX (latest API)
            configuration.Recoverability()
                .Failed(f => f.OnMessageSentToErrorQueue(async (context, token) =>
                {
                    var headers = context.Headers;

                    var messageId = headers.TryGetValue("NServiceBus.MessageId", out var id) ? id : "unknown";
                    var messageType = headers.TryGetValue("NServiceBus.EnclosedMessageTypes", out var type) ? type : "unknown";

                    var message = $"MessageId: {messageId}, Type: {messageType}";

                    _slackMessageSender.SendMessage(message, _logger);

                    await Task.CompletedTask;
                }));


            // ✅ Pipeline
            configuration.Pipeline.Register(
                new CustomErrorHandlingBehavior(_logger),
                "Registered CustomErrorHandlingBehavior");

            // ✅ ✅ ✅ DI FIX (modern)
            configuration.RegisterComponents(services =>
            {
                services.AddScoped<OperationsDbContext>();
            });

            return configuration;
        }
    }
}
