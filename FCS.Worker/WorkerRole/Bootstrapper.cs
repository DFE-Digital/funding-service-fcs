namespace WorkerRole
{
    using NServiceBus;
    using NServiceBus.MessageMutator;
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
    using Microsoft.WindowsAzure.ServiceRuntime;
    using SFA.FCS.Worker.Common.Slack;

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
            _logger.LogInformation("Stopping endpoints");

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

        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(ILoggerFactory loggerFactory)
        {
            _logger.LogInformation("Retrieving Endpoint Configurations");
            string endpointName = null;
            try
            {
                //List<Type> endpointTypes =
                //    GetDynamicTypes()
                //        .Where(t => !t.IsAbstract && t.GetInterfaces().Contains(typeof(IEndpointConfig))).ToList();

                List<Type> endpointTypes = new List<Type>
                {
                    typeof(AllocationDeliveryDomain.Endpoint.ActualsPull.EndpointConfig),
                    typeof(AllocationDeliveryDomain.Endpoint.ActualsPullComplete.EndpointConfig),
                    typeof(AllocationDeliveryDomain.Endpoint.ContractTerminationEndpoint.EndpointConfig),
                    typeof(AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.EndpointConfig),
                    typeof(AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.EndpointConfig),
                    typeof(AllocationDeliveryDomain.Endpoint.ReleaseHeldReportedActualsEndpoint.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.AmendContract.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.ContractCreated.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.CreateContract.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.CreateContractInternal.EndpointConfig),

                    typeof(ContractCreateDomain.Endpoint.CreateProvidersIfNecessary.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.EnrichForDocumentation.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.NonFinancialAmendment.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.Organisation.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.UpdateContract.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.UpdateDraftContractAmendment.EndpointConfig),
                    typeof(ContractCreateDomain.Endpoint.XrmService.EndpointConfig),
                    typeof(ContractCreateDomain.IncrementContractVersionEndpoint.EndPointConfig),
                    typeof(ContractManagementDomain.Endpoint.Xrm.ContractClosure.EndpointConfig),
                    typeof(ContractManagementDomain.Endpoint.Xrm.ContractNotification.EndpointConfig),

                    typeof(ContractManagementDomain.Endpoint.ConfirmPublicationToProvider.EndpointConfig),
                    typeof(ContractManagementDomain.Endpoint.ContractApproved.EndpointConfig),
                    typeof(ContractManagementDomain.Endpoint.ContractClosure.EndpointConfig),
                    typeof(ContractManagementDomain.Endpoint.DeleteContract.EndpointConfig),
                    typeof(ContractManagementDomain.Endpoint.InitiateContractApproval.EndpointConfig),
                    typeof(ContractManagementDomain.Endpoint.InitiateContractWithdrawal.EndpointConfig),
                    typeof(ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.EndpointConfig),
                    typeof(ContractManagementDomain.Endpoint.ReleaseForReview.EndpointConfig),
                    typeof(ContractManagementDomain.Termination.Xrm.EndpointConfig),
                    typeof(ContractManagementDomain.Termination.EndpointConfig),

                    typeof(ContractRequest.Cfs.AllocationCreated.EndpointConfig),
                    typeof(DocumentsDomain.Endpoint.ArchiveDocument.EndpointConfig),
                    typeof(DocumentsDomain.Endpoint.Xrm.EndpointConfig),
                    typeof(OrganisationDomain.Endpoint.Xrm.EndpointConfig),
                    typeof(PaymentGenerationDomain.Endpoint.PaymentPostedEndpoint.EndpointConfig),
                    typeof(PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint.EndpointConfig),
                    typeof(PaymentManagementDomain.AllocationActualsVerified.EndpointConfig),
                    typeof(PaymentManagementDomain.PaymentSchedule.DeliverableAggregation.EndpointConfig),
                    typeof(PaymentManagementDomain.PaymentSchedule.MissingDeliverablePeriod.EndpointConfig),
                    typeof(PaymentManagementDomain.PaymentSchedule.PaymentAggregated.EndpointConfig),

                    typeof(PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.EndpointConfig),
                    typeof(PerformanceManagementDomain.XrmEndpoint.EndpointConfig),
                    typeof(PerformanceManagementDomain.PullFundingClaim.EndpointConfig),
                    typeof(PerformanceManagementDomain.RecalculationInitiated.EndpointConfig),
                    typeof(PerformanceManagementDomain.ReconciliationCalculationEndpoint.EndPointConfig),
                    typeof(PerformanceManagementDomain.ReconciliationPublication.EndpointConfig),
                    typeof(OrganisationDomain.Integration.MainEndpoint.EndpointConfig),
                    typeof(OrganisationDomain.Integration.CpdsEndpoint.EndpointConfig),
                    typeof(OrganisationDomain.Integration.DataStoreEndpoint.EndpointConfig)
                };

                _logger.LogInformation($"We have found: {endpointTypes.Count} endpoints");

                List<EndpointConfiguration> endpointConfigurations = endpointTypes.Select(t =>
                {
                    IEndpointConfig endpoint = (IEndpointConfig) Activator.CreateInstance(t);

                    endpointName = endpoint.EndpointName;

                    _logger.LogInformation($"Getting configuration for endpoint: {endpoint.EndpointName} - Subscriptions: {endpoint.Subscriptions.Count}");

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
            _logger.LogInformation($"Endpoint Name: {endpoint.EndpointName} endpoints");

            if (endpoint.EndpointName == "ContractManagementDomain.ConfirmPublicationToProvider")
            {
                _logger.LogInformation($"ConfirmPublicationToProvider Endpoint Name");
                configuration.SendFailedMessagesTo(errorQueue: "ContractManagementDomain.ConfirmPublicationToProvider.error");
            }
            else
            {
                configuration.SendFailedMessagesTo(errorQueue: "error");
            }
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
                    ErrorMessageNotifier.SendMessage(m, _logger, "FCS.Worker");
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
