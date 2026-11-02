namespace Operations.Worker
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Threading.Tasks;
    using DataStore;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using NServiceBus.MessageMutator;
    using NServiceBus.Persistence.Sql;
    using Audit;
    using ServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Storage;
    using Slack;

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

            var f = Convert.ToBoolean(appConfiguration["ShouldMoveAuditMessagesToTable"]);

            if (Convert.ToBoolean(appConfiguration["ShouldMoveAuditMessagesToTable"]))
            {
                _logger.LogInformation("About to start listening for audit messages");
                var configuration = new FcsConfiguration(appConfiguration);
                try
                {
                    await QueueListener.BeginListening(m => FcsMessageProcessor.WriteAuditMessageToTable(m, configuration),
                        "audit", _logger, configuration);
                }
                catch (Exception e)
                {
                    _logger.LogInformation(1,$"Begin Listening has failed: {e.Message}, {e.StackTrace}");
                }
               
                _logger.LogInformation("Audit Queue Listener started");
            }
        }

        public static async Task Stop()
        {
            _logger.LogInformation("Stopping NServiceBus 6 endpoints");

            foreach (var endpoint in Endpoints)
            {
                await endpoint.Stop()
                    .ConfigureAwait(false);
            }
        }

        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(ILogger logger, IConfigurationRoot appConfiguration)
        {
            _logger.LogInformation("Retrieving Endpoint Configurations");
            string endpointName = null;
            FcsConfiguration configuration = new FcsConfiguration(appConfiguration);
            try
            {
                List<Type> endpointTypes =
                    new List<Type>
                    {
                        typeof(FCT.Operations.FundingAllocationExtract.EndpointConfig),
                        typeof(FCT.Operations.PaymentSummary.EndpointConfig),
                        typeof(FCT.Operations.Cda.ReportGeneration.EndpointConfig),
                        typeof(SFA.FCT.Operations.Integrity.EndpointConfig),
                        typeof(SFA.FCT.Operations.Maintenance.Endpoint.EndpointConfig),
                        typeof(FCT.Operations.Connectivity.EndpointConfig),
                        typeof(FCT.Operations.FundingConfirmationReport.EndpointConfig)
                        //todo: check this is the complete list
                    };

                _logger.LogInformation($"We have found: {endpointTypes.Count} endpoints");

                List<EndpointConfiguration> endpointConfigurations = endpointTypes.Select(t =>
                {
                    IEndpointConfigWithFcsConfig endpoint = (IEndpointConfigWithFcsConfig)Activator.CreateInstance(t);

                    endpointName = endpoint.EndpointName;

                    _logger.LogInformation($"Getting configuration for endpoint: {endpoint.EndpointName} - Subscriptions: {endpoint.Subscriptions.Count}");

                    return endpoint.GetBootstrapConfiguration(logger, configuration);
                })
                    .ToList();

                return await Task.WhenAll(endpointConfigurations.Select(Endpoint.Start).ToList());
            }
            catch (Exception e)
            {
                ReflectionTypeLoadException reflectionException = e as ReflectionTypeLoadException;
                _logger.LogInformation($"StartEndpoints has failed: {endpointName}, {e.Message} - {reflectionException?.LoaderExceptions?.FirstOrDefault()}");
                _logger.LogInformation($"StartEndpoints stacktrace: {e.StackTrace}");

                throw;
            }
        }

        private static EndpointConfiguration GetBootstrapConfiguration(this IEndpointConfigWithFcsConfig endpoint,
            ILogger logger, IFcsConfiguration appConfiguration)
        {
            EndpointConfiguration configuration = endpoint.GetEndpointConfiguration(logger, appConfiguration);

            var persistence = configuration.UsePersistence<SqlPersistence, StorageType.Sagas>();
            configuration.UsePersistence<SqlPersistence, StorageType.Subscriptions>();
            configuration.UsePersistence<SqlPersistence, StorageType.Timeouts>();

            persistence.SqlDialect<SqlDialect.MsSqlServer>();

            persistence.ConnectionBuilder(() =>
                new SqlConnection(appConfiguration["ConnectionStrings:NServiceBus/Persistence"]));

            var scanner = configuration.AssemblyScanner();

            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            var referencedAssemblies = Assembly.LoadFrom(endpoint.NameOfAssembly).GetReferencedAssemblies()
                .Select(a => $"{a.Name}.dll");

            var assembliesToExclude = Directory.EnumerateFiles(baseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .Where(
                    fn => fn != endpoint.NameOfAssembly && !referencedAssemblies.Contains(fn) ||
                          Nsb5Assemblies.Contains(fn))
                .ToArray();

            scanner.ExcludeAssemblies(assembliesToExclude);

            var transport = configuration.UseTransport<AzureServiceBusTransport>(); // must use Forwarding topology in later Azure Service Bus transport
            transport.Transactions(TransportTransactionMode.ReceiveOnly);
            transport.ConnectionString(appConfiguration["ConnectionStrings:NServiceBus/Transport"])
                .TopicName($"{endpoint.EndpointName}.events");

            /*
            Subscriptions auto registered in later Azure Service Bus transport
            
            foreach (var subscription in endpoint.Subscriptions)
            {
                transport.RegisterPublisher(subscription.EventType, subscription.PublisherName);
            }
            */

            /*
            Lock duration is set automatically to the ASB max of 5 minutes in later Azure Service Bus transport
            https://docs.particular.net/transports/upgrades/asb-10toasbs-1
            
            transport.Subscriptions().LockDuration(TimeSpan.FromMinutes(5));
            transport.Queues().LockDuration(TimeSpan.FromMinutes(5));
            */

            foreach (var route in endpoint.Routes)
            {
                transport.Routing().RouteToEndpoint(route.CommandType, route.Destination);
            }

            /*
            Removed from later Azure Service Bus transport, if necessary a shortner for subscription names can be configured
            https://docs.particular.net/transports/upgrades/asb-10toasbs-1
            
            transport.Sanitization().UseStrategy<ValidateAndHashIfNeeded>();
            */

            configuration.UseSerialization<NewtonsoftSerializer>();

            configuration.EnableInstallers();
            configuration.RegisterMessageMutator(new TransportMessageCompressionMutator(_logger, new LargeMessageStorageService(((FcsConfiguration)appConfiguration).ConfigurationRoot)));

            configuration.AuditProcessedMessagesTo(
                auditQueue: "audit",
                timeToBeReceived: TimeSpan.FromDays(7));

            configuration.SendFailedMessagesTo(errorQueue: "error");

            SendErrorMessagesToSlackInNecessary(configuration, ((FcsConfiguration)appConfiguration).ConfigurationRoot);

            var pipeline = configuration.Pipeline;
            pipeline.Register(
                behavior: new CustomErrorHandlingBehavior(_logger),
                description: "Registered CustomErrorHandlingBehavior");

            configuration.RegisterComponents(c =>
            {
                c.ConfigureComponent(b =>
                {
                    var session = b.Build<ISqlStorageSession>();

                    //var context = new OperationsDbContext(new DbContextOptionsBuilder<OperationsDbContext>()
                    //    .UseSqlServer(session.Connection)
                    //    .Options);

                    ////Use the same underlying ADO.NET transaction
                    //context.Database.UseTransaction(session.Transaction);

                    ////Ensure context is flushed before the transaction is committed
                    //session.OnSaveChanges(s => context.SaveChangesAsync());

                    //return context;
                    // todo: sort this out later.
                    return new OperationsDbContext();
                }, DependencyLifecycle.InstancePerUnitOfWork);
            });

            return configuration;
        }

        private static void SendErrorMessagesToSlackInNecessary(EndpointConfiguration endpointConfiguration, IConfigurationRoot appConfiguration)
        {
            string shouldSendToSlack = appConfiguration["Slack:ShouldSend"];

            if (shouldSendToSlack == "true")
            {
                endpointConfiguration.Notifications.Errors.MessageSentToErrorQueue += (o, m) =>
                {
                    _slackMessageSender.SendMessage(m, _logger);
                };
            }
        }
    }
}
