namespace SFA.FCT.CrossDomain.Integration.Azure.Worker
{
    using NServiceBus;
    using NServiceBus.MessageMutator;
    using NServiceBus.Persistence;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Threading.Tasks;
    using NServiceBus.Persistence.Sql;
    using SFA.FCS.Worker.Common;
    using System.Data.SqlClient;
    using System.Configuration;
    using global::AllocationDeliveryDomain.Endpoint.MonthEndCheck;
    using global::AllocationDeliveryDomain.Endpoint.Routing;
    using global::AllocationDeliveryDomain.Endpoint.Validation;
    using ReportRunnerEndpoint=global::CrossDomain.Integration.ReportRunnerEndpoint;
    using EngagementWatcher=global::ContractRequestDomain.EngagementWatcher;


    using Microsoft.WindowsAzure.ServiceRuntime;
    using Slack;

    public static class Bootstrapper
    {
        private static ILogger _logger;

        public static IReadOnlyCollection<IEndpointInstance> Endpoints { get; private set; }

        private static string[] Nsb5Assemblies => new string[]
        {
            "CrossDomain.Integration.Common.dll",
            "PaymentManagementDomain.PaymentSchedule.Xrm.Integration.dll"
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
            FindDeploymentAndRoleInfo(currentLogger);
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

            var id = Guid.NewGuid();  // temp debug line
            Console.WriteLine($"currentDirectory {currentDirectory}-{id}"); // temp debug line

            List<string> assemblyNames = Directory.GetFiles(currentDirectory, "*.dll")
                                             .Where(f => !ExcludedWordsInAssemblies.Any(f.Contains) && !Nsb5Assemblies.Any(f.Contains)).ToList();

            Console.WriteLine($"This Console.WriteLine added to Bootstrapper.cs in XDomain.Worker-{id}"); // temp debug line

            Console.WriteLine($"assemblyNames count {assemblyNames.Count}-{id}"); // temp debug line

            int loopCount = 0; // temp debug line

            // the code below can be removed later
            assemblyNames.ForEach(a =>
            {
                try
                {
                    loopCount++; // temp debug line
                    Console.WriteLine($"assemblyName-{loopCount}-{a}-{id}"); // temp debug line
                    Assembly.LoadFile(Path.Combine(Environment.CurrentDirectory, a)).GetTypes();
                }
                catch (ReflectionTypeLoadException e)
                {
                    Console.WriteLine($"assemblyName-{loopCount}-{a}-{id}-catch-Could not load - {a} because {e.LoaderExceptions.FirstOrDefault()}"); // temp debug line
                    _logger.LogInformation($"Could not load - {a} because {e.LoaderExceptions.FirstOrDefault()}");
                }
            });

            return assemblyNames.SelectMany(p => Assembly.LoadFile(Path.Combine(Environment.CurrentDirectory, p)).GetTypes());
        }

        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(ILoggerFactory loggerFactory)
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
                        typeof(ADMonitoringDomain.Endpoint.EndpointConfig),
                        typeof(MonthEndCheckConfig),
                        typeof(DedsReportedActualRoutingConfig),
                        typeof(ValidationEndpointConfig),
                        typeof(SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint.EndpointConfig),
                        typeof(ReportRunnerEndpoint.EndpointConfig),
                        typeof(SFA.FCT.ContractManagementDomain.Integration.IntegrationEndpoint.EndpointConfig),
                        typeof(SFA.FCT.ContractManagementDomain.Integration.PublishContractToProviderEndpoint.EndpointConfig),
                        typeof(SFA.FCT.ContractManagementDomain.Integration.PublishContractWithdrawalEndpoint.EndpointConfig),
                        typeof(EngagementWatcher.EndpointConfig),
                        typeof(SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.EndpointConfig),
                        typeof(SFA.FCT.ContractRequestDomain.Integration.BulkUpload.EndpointConfig),
                        typeof(SFA.FCT.ContractRequestDomain.Integration.FileWatcher.EndpointConfig),
                        typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentDeleteEndpoint.DocumentDeleterEndpointConfig),
                        typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentMergeEndpoint.DocumentMergeEndpointConfig),
                        typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentMoveEndpoint.DocumentMoveEndpointConfig),
                        typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentSaverEndpoint.DocumentSaverEndpointConfig),
                        typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentGenerationEndpointConfig),
                        typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint.EndpointConfig),
                        typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint.EndpointConfig),
                        typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentRunEndpoint.EndpointConfig),
                        typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint.EndpointConfig),
                        typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunErrorEndpoint.EndpointConfig),
                        typeof(SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.PaymentAggregationEndpointConfig),
                        typeof(SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.PaymentManagementEndpointConfig),
                        typeof(SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.EndpointConfig)
                    };

                _logger.LogInformation($"We have found: {endpointTypes.Count} endpoints");

                List<EndpointConfiguration> endpointConfigurations = endpointTypes.Select(t =>
                {
                    IEndpointConfig endpoint = (IEndpointConfig)Activator.CreateInstance(t);

                    endpointName = endpoint.EndpointName;

                    _logger.LogInformation($"Getting configuration for endpoint: {endpoint.EndpointName} - Subscriptions: {endpoint.Subscriptions.Count}");

                    return endpoint.GetBootstrapConfiguration(loggerFactory);
                })
                    .ToList();

                return await Task.WhenAll(endpointConfigurations.Select(Endpoint.Start).ToList());
                //// todo: put back line
                // IReadOnlyCollection<IEndpointInstance> endpoints = endpointConfigurations.Select(e =>
                // {
                //     return Endpoint.Start(e).Result;
                // }).ToList();

                // return endpoints;
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
            configuration.UsePersistence<SqlPersistence>();

            persistence.SqlDialect<SqlDialect.MsSqlServer>();

            persistence.ConnectionBuilder(() => new SqlConnection(ConfigurationManager.ConnectionStrings["NServiceBus/Persistence"].ConnectionString));

            var scanner = configuration.AssemblyScanner();

            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            var referencedAssemblies = Assembly.LoadFrom(endpoint.NameOfAssembly).GetReferencedAssemblies().Select(a => $"{a.Name}.dll");

            var assembliesToExclude = Directory.EnumerateFiles(baseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .Where(
                    fn => fn != endpoint.NameOfAssembly && !referencedAssemblies.Contains(fn) || Nsb5Assemblies.Contains(fn))
                .ToArray();

            scanner.ExcludeAssemblies(assembliesToExclude);

            var transport = configuration.UseTransport<AzureServiceBusTransport>()
                .UseEndpointOrientedTopology();
            transport.Transactions(TransportTransactionMode.ReceiveOnly);

            foreach (var subscription in endpoint.Subscriptions)
            {
                transport.RegisterPublisher(subscription.EventType, subscription.PublisherName);
            }

            transport.Subscriptions().LockDuration(TimeSpan.FromMinutes(5));
            transport.Queues().LockDuration(TimeSpan.FromMinutes(5));

            foreach (var route in endpoint.Routes)
            {
                transport.Routing().RouteToEndpoint(route.CommandType, route.Destination);
            }

            transport.Sanitization().UseStrategy<ValidateAndHashIfNeeded>();

            configuration.UseSerialization<NewtonsoftSerializer>();

            configuration.EnableInstallers();
            configuration.RegisterMessageMutator(new TransportMessageCompressionMutator(_logger));

            configuration.AuditProcessedMessagesTo(
                auditQueue: "audit",
                timeToBeReceived: TimeSpan.FromDays(7));

            configuration.SendFailedMessagesTo(errorQueue: "error");

            SendErrorMessagesToSlackInNecessary(configuration);

            var pipeline = configuration.Pipeline;
            pipeline.Register(
                behavior: new CustomErrorHandlingBehavior(_logger),
                description: "Registered CustomErrorHandlingBehavior");

            return configuration;
        }

        private static void SendErrorMessagesToSlackInNecessary(EndpointConfiguration configuration)
        {
            string shouldSendToSlack = ConfigurationManager.AppSettings["SlackError:ShouldSend"];

            if (shouldSendToSlack == "true")
            {
                configuration.Notifications.Errors.MessageSentToErrorQueue += (o, m) =>
                {
                    ErrorMessageNotifier.SendMessge(m, _logger, "CrossDomain.Integration");
                };
            }
        }

        private static void FindDeploymentAndRoleInfo(ILogger logger)
        {
            try
            {
                logger.LogInformation($"The deployment id is - {RoleEnvironment.DeploymentId}");
                logger.LogInformation($"The RoleEnvironment.CurrentRoleInstance.Id is - {RoleEnvironment.CurrentRoleInstance.Id}");
                logger.LogInformation($"The RoleEnvironment.CurrentRoleInstance.Role.Name is - {RoleEnvironment.CurrentRoleInstance.Role.Name}");
                logger.LogInformation($"The RoleEnvironment.CurrentRoleInstance.ToString() is - {RoleEnvironment.CurrentRoleInstance}");
            }
            catch (Exception e)
            {
                logger.LogInformation($"The deployment id cannot be found - {e.Message}");
            }
        }
    }
}
