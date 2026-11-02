namespace AllocationDeliveryPerformance
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Threading.Tasks;
    using ActualsPull;
    using ActualsPull.NSB;
    using ActualsPull.Slack;
    using NServiceBus;
    using NServiceBus.MessageMutator;
    using NServiceBus.Persistence.Sql;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class Bootstrapper
    {
        private static ILogger _logger;

        public static IReadOnlyCollection<IEndpointInstance> Endpoints { get; private set; }

        private static string[] Nsb5Assemblies => new string[]
        {
            "CrossDomain.Integration.Common.dll"
        };

        private static string[] ExcludedWordsInAssemblies => new string[]
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

        public static async Task Start(ILoggerFactory loggerFactory, ILogger currentLogger)
        {
            _logger = currentLogger;
            Endpoints = await StartEndpoints(loggerFactory);
            _logger.LogInformation("All endpoints have started");
            //FindDeploymentAndRoleInfo(currentLogger);
        }

        private static IEnumerable<Type> GetDynamicTypes()
        {
            Assembly thisAssembly = Assembly.GetExecutingAssembly();

            return thisAssembly.GetTypes().ToList();
        }

        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(ILoggerFactory loggerFactory)
        {
            _logger.LogInformation("Retrieving Endpoint Configurations");
            string endpointName = null;
            try
            {
                List<Type> endpointTypes =
                    GetDynamicTypes()
                        .Where(t => !t.IsAbstract && t.GetInterfaces().Contains(typeof(IEndpointConfig))).ToList();

                _logger.LogInformation($"We have found: {endpointTypes.Count} endpoints");

                List<EndpointConfiguration> endpointConfigurations = endpointTypes.Select(t =>
                {
                    IEndpointConfig endpoint = (IEndpointConfig)Activator.CreateInstance(t);

                    endpointName = endpoint.EndpointName;

                    //_logger.LogInformation($"Getting configuration for endpoint: {endpoint.EndpointName} - Subscriptions: {endpoint.Subscriptions.Count}");

                    return endpoint.GetBootstrapConfiguration(loggerFactory);
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

        private static EndpointConfiguration GetBootstrapConfiguration(this IEndpointConfig endpoint, ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = endpoint.GetEndpointConfiguration(loggerFactory);

            var persistence = configuration.UsePersistence<SqlPersistence, StorageType.Sagas>();
            configuration.UsePersistence<SqlPersistence, StorageType.Subscriptions>();
            configuration.UsePersistence<SqlPersistence, StorageType.Timeouts>();

            persistence.SqlDialect<SqlDialect.MsSqlServer>();

            persistence.ConnectionBuilder(() => new SqlConnection(Config.GetAppSetting("Environment:SqlDatabaseConnectionString")));

            var scanner = configuration.AssemblyScanner();

            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            var referencedAssemblies = Assembly.LoadFrom(endpoint.NameOfAssembly).GetReferencedAssemblies().Select(a => $"{a.Name}.dll");

            var assembliesToExclude = Directory.EnumerateFiles(baseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .Where(
                    fn => fn != endpoint.NameOfAssembly && !referencedAssemblies.Contains(fn) || Nsb5Assemblies.Contains(fn))
                .ToArray();

            scanner.ExcludeAssemblies(assembliesToExclude);

            TransportExtensions<AzureServiceBusTransport> transport = configuration.UseTransport<AzureServiceBusTransport>();
                
            transport.Transactions(TransportTransactionMode.ReceiveOnly);
            transport.ConnectionString(Config.GetAppSetting("Environment:AzureServiceBus"));

            //foreach (var subscription in endpoint.Subscriptions)
            //{
            //    transport.RegisterPublisher(subscription.EventType, subscription.PublisherName);
            //}

            //transport.Subscriptions().LockDuration(TimeSpan.FromMinutes(5));
            //transport.Queues().LockDuration(TimeSpan.FromMinutes(5));

            //foreach (var route in endpoint.Routes)
            //{
            //    transport.Routing().RouteToEndpoint(route.CommandType, route.Destination);
            //}

            //transport.Sanitization().UseStrategy<ValidateAndHashIfNeeded>();

            configuration.UseSerialization<NewtonsoftSerializer>();

            configuration.EnableInstallers();
            configuration.RegisterMessageMutator(new TransportMessageCompressionMutator(_logger));

            configuration.AuditProcessedMessagesTo(
                auditQueue: "audit",
                timeToBeReceived: TimeSpan.FromMinutes(60));

            configuration.SendFailedMessagesTo(errorQueue: "error");

            SendErrorMessagesToSlackInNecessary(configuration);

            var pipeline = configuration.Pipeline;
            pipeline.Register(
                behavior: new CustomErrorHandlingBehavior(_logger),
                description: "Registered CustomErrorHandlingBehavior");

            configuration.License(Config.GetAppSetting("NServiceBusLicense"));

            return configuration;
        }

        private static void SendErrorMessagesToSlackInNecessary(EndpointConfiguration configuration)
        {
            string shouldSendToSlack = Config.GetAppSetting("SlackError:ShouldSend");

            if (shouldSendToSlack == "true")
            {
                configuration.Notifications.Errors.MessageSentToErrorQueue += (o, m) =>
                {
                    ErrorMessageNotifier.SendMessge(m, _logger);
                };
            }
        }
    }
}
