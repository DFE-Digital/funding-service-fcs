namespace FundingAllocation.ServiceBus
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Net.Http;
    using System.Reflection;
    using System.Threading.Tasks;
    using DataStore;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using NServiceBus.MessageMutator;
    using NServiceBus.Persistence.Sql;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Slack;
    using Storage;

    public static class Bootstrapper
    {
        private static ILogger _logger;
        private static ISlackMessageSender _slackMessageSender;
        private static IHttpClientFactory _httpClientFactory;

        public static IReadOnlyCollection<IEndpointInstance> Endpoints { get; private set; }

        private static string[] Nsb5Assemblies => new[]
        {
            "CrossDomain.Integration.Common.dll",
            "PaymentManagementDomain.PaymentSchedule.Xrm.Integration.dll"
        };

        private static string[] ExcludedWordsInAssemblies => new[]
        {
            "Microsoft",
            "Castle",
            "Aspose",
            "Oracle",
            "NServiceBus",
            "System",
            "Azure",
            "Common",
        };

        public static async Task Start(
            ILoggerFactory loggerFactory,
            ILogger currentLogger,
            IConfigurationRoot appConfiguration,
            IHttpClientFactory httpClientFactory)
        {
            _logger = currentLogger;
            _httpClientFactory = httpClientFactory;
            _slackMessageSender    = new SlackMessageSender(appConfiguration);
            Endpoints = await StartEndpoints(loggerFactory.CreateCoreLogger(), appConfiguration);
            _logger.LogInformation("All endpoints have started");
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

        private static IEnumerable<Type> GetDynamicTypes()
        {
            string currentDirectory = AppDomain.CurrentDomain.BaseDirectory;

            List<string> assemblyNames = Directory.GetFiles(currentDirectory, "*.dll")
                                             .Where(f => !ExcludedWordsInAssemblies.Any(f.Contains) && !Nsb5Assemblies.Any(f.Contains)).ToList();

            // the code below can be removed later
            assemblyNames.ForEach(a =>
            {
                try
                {
                    Assembly.LoadFile(Path.Combine(Environment.CurrentDirectory, a)).GetTypes();
                }
                catch (ReflectionTypeLoadException e)
                {
                    _logger.LogInformation($"Could not load - {a} because {e.LoaderExceptions.FirstOrDefault()}");
                }

            });

            return assemblyNames.SelectMany(p => Assembly.LoadFile(Path.Combine(Environment.CurrentDirectory, p)).GetTypes());
        }

        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(ILogger logger, IConfigurationRoot appConfiguration)
        {
            _logger.LogInformation("Retrieving Endpoint Configurations");
            string endpointName = null;
            try
            {
                List<Type> endpointTypes =
                    //GetDynamicTypes()
                    //    .Where(t => !t.IsAbstract && t.GetInterfaces().Contains(typeof(IEndpointCoreConfig))).ToList();
                    new List<Type>
                    {
                        typeof(Endpoints.PullFundingAllocation.EndpointConfig),
                        typeof(Endpoints.GetFundingAllocationsPage.EndpointConfig),
                        typeof(Endpoints.EnrichProviderFunding.EndpointConfig),
                        typeof(Endpoints.CreateFundingAllocationInCrm.EndpointConfig),
                        typeof(Endpoints.ReleaseGroup.EndpointConfig),
                        typeof(Endpoints.DocumentGenerationComplete.EndpointConfig),
                        typeof(Endpoints.ContractApproved.EndpointConfig),
                        typeof(Endpoints.UpdateFundingAllocation.EndpointConfig),
                        typeof(Endpoints.ReleaseGroupSetToReleased.EndpointConfig),
                        typeof(Endpoints.CheckForReadComplete.EndpointConfig),
                        typeof(Endpoints.ContractWithdrawn.EndpointConfig),
                        typeof(Endpoints.DraftContractDeleted.EndpointConfig),
                        typeof(Endpoints.UnParkFundingAllocation.EndpointConfig),
                        typeof(Endpoints.CheckForJobComplete.EndpointConfig),
                        typeof(Endpoints.CreateProvidersIfNecessaryReply.EndpointConfig),
                        typeof(Endpoints.JobCompleted.EndpointConfig),
                        typeof(Endpoints.CheckForMissingProvidersPostReadComplete.EndpointConfig),
                        typeof(Endpoints.BulkUpload.EndpointConfig),
                        typeof(Endpoints.IgnoreItemsOfNoInterest.EndpointConfig),
                        typeof(Endpoints.ContractPublished.EndpointConfig),
                        typeof(Endpoints.Operational.EndpointConfig),
                    };

                _logger.LogInformation($"We have found: {endpointTypes.Count} endpoints");

                List<EndpointConfiguration> endpointConfigurations = endpointTypes.Select(t =>
                {
                    IEndpointCoreConfig endpoint = (IEndpointCoreConfig)Activator.CreateInstance(t);

                    endpointName = endpoint.EndpointName;

                    _logger.LogInformation($"Getting configuration for endpoint: {endpoint.EndpointName} - Subscriptions: {endpoint.Subscriptions.Count}");

                    return endpoint.GetBootstrapConfiguration(logger, appConfiguration);
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

        private static EndpointConfiguration GetBootstrapConfiguration(this IEndpointCoreConfig endpoint,
            ILogger logger, IConfigurationRoot appConfiguration)
        {
            EndpointConfiguration configuration = endpoint.GetEndpointConfiguration(logger, appConfiguration);

            var persistence = configuration.UsePersistence<SqlPersistence, StorageType.Sagas>();
            configuration.UsePersistence<SqlPersistence, StorageType.Subscriptions>();
            configuration.UsePersistence<SqlPersistence, StorageType.Timeouts>();

            persistence.SqlDialect<SqlDialect.MsSqlServer>();

            persistence.ConnectionBuilder(() =>
                new SqlConnection(appConfiguration.GetConnectionString("NServiceBus/Persistence")));

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
            transport.ConnectionString(appConfiguration.GetConnectionString("NServiceBus/Transport"))
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
            configuration.RegisterMessageMutator(new TransportMessageCompressionMutator(_logger, new LargeMessageStorageService(appConfiguration)));

            configuration.AuditProcessedMessagesTo(
                auditQueue: "audit",
                timeToBeReceived: TimeSpan.FromDays(7));

            configuration.SendFailedMessagesTo(errorQueue: "error");

            SendErrorMessagesToSlackInNecessary(configuration, appConfiguration);

            var pipeline = configuration.Pipeline;
            pipeline.Register(
                behavior: new CustomErrorHandlingBehavior(_logger),
                description: "Registered CustomErrorHandlingBehavior");

            configuration.RegisterComponents(c =>
            {
                c.ConfigureComponent(b =>
                {
                    var session = b.Build<ISqlStorageSession>();

                    var context = new FundingAllocationContext(new DbContextOptionsBuilder<FundingAllocationContext>()
                        .UseSqlServer(session.Connection)
                        .Options);

                    //Use the same underlying ADO.NET transaction
                    context.Database.UseTransaction(session.Transaction);

                    //Ensure context is flushed before the transaction is committed
                    session.OnSaveChanges(s => context.SaveChangesAsync());

                    return context;
                }, DependencyLifecycle.InstancePerUnitOfWork);
                c.ConfigureComponent(() => _httpClientFactory, DependencyLifecycle.SingleInstance);
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
                    _slackMessageSender.SendMessage(m, _logger, SlackChannel.General);
                };
            }
        }
    }
}
