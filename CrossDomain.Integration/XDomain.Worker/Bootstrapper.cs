
namespace SFA.FCT.CrossDomain.Integration.Azure.Worker
{
    // -----------------------------
    // System
    // -----------------------------
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;

    // -----------------------------
    // Microsoft
    // -----------------------------
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.Logging;
    using Microsoft.Data.SqlClient;

    // -----------------------------
    // NServiceBus
    // -----------------------------
    using NServiceBus;
    using NServiceBus.Transport.AzureServiceBus;
    using NServiceBus.Persistence.Sql;

    // ✅ Resolve ambiguity
    using NSBEndpointConfiguration = NServiceBus.EndpointConfiguration;

    // -----------------------------
    // Your framework
    // -----------------------------
    using SFA.FCS.Worker.Common;

    public static class Bootstrapper
    {
        private static ILogger _logger;

        public static IReadOnlyCollection<IEndpointInstance> Endpoints { get; private set; }

        // -----------------------------------------------------
        // START
        // -----------------------------------------------------
        public static async Task Start(
            ILoggerFactory loggerFactory,
            ILogger currentLogger,
            IConfiguration configuration)
        {
            _logger = currentLogger;

            LogEnvironmentInfo(_logger);

            Endpoints = await StartEndpoints(loggerFactory, configuration);

            _logger.LogInformation("✅ All endpoints have started");
        }

        // -----------------------------------------------------
        // STOP
        // -----------------------------------------------------
        public static async Task Stop()
        {
            if (Endpoints == null) return;

            _logger.LogInformation("🛑 Stopping NServiceBus endpoints");

            foreach (var endpoint in Endpoints)
            {
                await endpoint.Stop().ConfigureAwait(false);
            }

            _logger.LogInformation("✅ All endpoints stopped");
        }

        // -----------------------------------------------------
        // START ENDPOINTS
        // -----------------------------------------------------
        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(
            ILoggerFactory loggerFactory,
            IConfiguration configuration)
        {
            _logger.LogInformation("🔍 Retrieving Endpoint Configurations");

            string endpointName = null;

            try
            {
                var endpointTypes = new List<Type>
                {
                    // ✅ Keep your existing list
                    typeof(SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.PaymentManagementEndpointConfig),
                    typeof(SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.PaymentAggregationEndpointConfig),
                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint.EndpointConfig),
                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint.EndpointConfig),
                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentRunEndpoint.EndpointConfig),
                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint.EndpointConfig),
                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunErrorEndpoint.EndpointConfig)
                    // 👉 add remaining endpoints
                };

                _logger.LogInformation("Found {Count} endpoints", endpointTypes.Count);

                var endpointConfigurations = endpointTypes.Select(type =>
                {
                    var endpoint = (IEndpointConfig)Activator.CreateInstance(type);

                    endpointName = endpoint.EndpointName;

                    _logger.LogInformation(
                        "⚙️ Configuring endpoint: {EndpointName}",
                        endpoint.EndpointName);

                    return BuildConfiguration(endpoint, loggerFactory, configuration);
                });

                return await Task.WhenAll(
                    endpointConfigurations.Select(config => Endpoint.Start(config)));

            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "❌ Failed to start endpoint: {EndpointName}", endpointName);
                throw;
            }
        }

        // -----------------------------------------------------
        // BUILD CONFIGURATION (CORE LOGIC)
        // -----------------------------------------------------
        private static NSBEndpointConfiguration BuildConfiguration(
            IEndpointConfig endpoint,
            ILoggerFactory loggerFactory,
            IConfiguration configuration)
        {
            var config = endpoint.GetEndpointConfiguration(loggerFactory);

            var serviceBusConnection =
                configuration.GetConnectionString("ServiceBus");

            var sqlConnection =
                configuration.GetConnectionString("NServiceBusPersistence");

            // ✅ TRANSPORT (CENTRALISED)
            config.UseTransport(
                new AzureServiceBusTransport(
                    serviceBusConnection,
                    TopicTopology.Default));

            // ✅ ROUTING (FIXED)


            var transport = config.UseTransport(
                new AzureServiceBusTransport(serviceBusConnection, TopicTopology.Default));

            // ✅ Command routing (directly on transport)
            foreach (var route in endpoint.Routes)
            {
                transport.RouteToEndpoint(route.CommandType, route.Destination);
            }

            // ✅ PERSISTENCE
            var persistence = config.UsePersistence<SqlPersistence>();
            persistence.SqlDialect<SqlDialect.MsSqlServer>();
            persistence.ConnectionBuilder(() => new SqlConnection(sqlConnection));

            // ✅ RECOVERABILITY
            config.Recoverability()
                .Immediate(i => i.NumberOfRetries(3))
                .Delayed(d =>
                {
                    d.NumberOfRetries(3);
                    d.TimeIncrease(TimeSpan.FromSeconds(5));
                });

            // ✅ INFRASTRUCTURE
            config.EnableInstallers();
            config.SendFailedMessagesTo("error");
            config.AuditProcessedMessagesTo("audit");

            return config;
        }

        // -----------------------------------------------------
        // ENVIRONMENT LOGGING
        // -----------------------------------------------------
        private static void LogEnvironmentInfo(ILogger logger)
        {
            try
            {
                logger.LogInformation("Machine: {Machine}", Environment.MachineName);
                logger.LogInformation("ProcessId: {Pid}", Environment.ProcessId);
                logger.LogInformation("App: {App}", Environment.GetEnvironmentVariable("WEBSITE_SITE_NAME"));
                logger.LogInformation("Instance: {Instance}", Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID"));
            }
            catch (Exception ex)
            {
                logger.LogWarning(ex, "Environment info unavailable");
            }
        }
    }
}



    //    public static class Bootstrapper
    //    {
    //        private static ILogger _logger;

    //        public static IReadOnlyCollection<IEndpointInstance> Endpoints { get; private set; }

    //        public static async Task Start(ILoggerFactory loggerFactory, ILogger currentLogger, IConfiguration configuration)
    //        {
    //            _logger = currentLogger;

    //            LogEnvironmentInfo(currentLogger);

    //            Endpoints = await StartEndpoints(loggerFactory, configuration);

    //            _logger.LogInformation("All endpoints have started");
    //        }

    //        public static async Task Stop()
    //        {
    //            if (Endpoints == null) return;

    //            _logger.LogInformation("Stopping NServiceBus endpoints");

    //            foreach (var endpoint in Endpoints)
    //            {
    //                await endpoint.Stop().ConfigureAwait(false);
    //            }
    //        }

    //        private static async Task<IReadOnlyCollection<IEndpointInstance>> StartEndpoints(
    //            ILoggerFactory loggerFactory,
    //            IConfiguration configuration)
    //        {
    //            _logger.LogInformation("Retrieving Endpoint Configurations");

    //            string endpointName = null;

    //            try
    //            {
    //                List<Type> endpointTypes = new List<Type>
    //                {
    //                    typeof(ADMonitoringDomain.Endpoint.EndpointConfig),
    //                    typeof(MonthEndCheckConfig),
    //                    typeof(DedsReportedActualRoutingConfig),
    //                    typeof(ValidationEndpointConfig),
    //                    typeof(SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint.EndpointConfig),
    //                    //typeof(CrossDomain.Integration.ReportRunnerEndpoint.EndpointConfig),
    //                    typeof(SFA.FCT.ContractManagementDomain.Integration.IntegrationEndpoint.EndpointConfig),
    //                    typeof(SFA.FCT.ContractManagementDomain.Integration.PublishContractToProviderEndpoint.EndpointConfig),
    //                    typeof(SFA.FCT.ContractManagementDomain.Integration.PublishContractWithdrawalEndpoint.EndpointConfig),
    //                    typeof(SFA.FCT.ContractRequestDomain.EngagementWatcher.EndpointConfig),
    //                    typeof(SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.EndpointConfig),
    //                    typeof(SFA.FCT.ContractRequestDomain.Integration.BulkUpload.EndpointConfig),
    //                    typeof(SFA.FCT.ContractRequestDomain.Integration.FileWatcher.EndpointConfig),
    //                    typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentDeleteEndpoint.DocumentDeleterEndpointConfig),
    //                    typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentMergeEndpoint.DocumentMergeEndpointConfig),
    //                    typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentMoveEndpoint.DocumentMoveEndpointConfig),
    //                    typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentSaverEndpoint.DocumentSaverEndpointConfig),
    //                    typeof(SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentGenerationEndpointConfig),
    //                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint.EndpointConfig),
    //                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint.EndpointConfig),
    //                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentRunEndpoint.EndpointConfig),
    //                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint.EndpointConfig),
    //                    typeof(PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunErrorEndpoint.EndpointConfig),
    //                    typeof(SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.PaymentAggregationEndpointConfig),
    //                    typeof(SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.PaymentManagementEndpointConfig),
    //                    typeof(SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.EndpointConfig)
    //                };

    //                _logger.LogInformation($"Found {endpointTypes.Count} endpoints");

    //                var endpointConfigurations = endpointTypes.Select(t =>
    //                {
    //                    var endpoint = (IEndpointConfig)Activator.CreateInstance(t);

    //                    endpointName = endpoint.EndpointName;

    //                    _logger.LogInformation(
    //                        $"Configuring endpoint: {endpoint.EndpointName} - Subscriptions: {endpoint.Subscriptions.Count}");

    //                    return endpoint.GetBootstrapConfiguration(loggerFactory, configuration);
    //                }).ToList();


    //                return await Task.WhenAll(
    //                    endpointConfigurations.Select(ec => Endpoint.Start(ec))
    //                );

    //            }
    //            catch (Exception e)
    //            {
    //                _logger.LogInformation(e, $"StartEndpoints failed for: {endpointName}");
    //                throw;
    //            }
    //        }

    //        private static NServiceBus.EndpointConfiguration GetBootstrapConfiguration(
    //            this IEndpointConfig endpoint,ILoggerFactory loggerFactory,
    //            IConfiguration configuration)
    //        {
    //            var config = endpoint.GetEndpointConfiguration(loggerFactory);

    //            var connectionString = configuration.GetConnectionString("NServiceBusPersistence");

    //            // Persistence

    //            var persistence = config.UsePersistence<SqlPersistence>();
    //            persistence.SqlDialect<SqlDialect.MsSqlServer>();
    //            persistence.ConnectionBuilder(() => new SqlConnection(connectionString));




    //            // ✅ Topology
    //            var topology = TopicTopology.Default;

    //            // ✅ Transport instance
    //            var transport = new AzureServiceBusTransport(connectionString, topology);

    //            // ✅ Attach transport AND capture settings
    //            var transportSettings = config.UseTransport(transport);

    //            // ✅ Routing from settings
    //            //var routing = config.UseRouting();

    //            //// ✅ Pub/Sub
    //            //foreach (var subscription in endpoint.Subscriptions)
    //            //{
    //            //    routing.RegisterPublisher(subscription.EventType, subscription.PublisherName);
    //            //}

    //            //// ✅ Command routing
    //            //foreach (var route in endpoint.Routes)
    //            //{
    //            //    routing.RouteToEndpoint(route.CommandType, route.Destination);
    //            //}





    //            // Lock durations
    //            //transport.Subscriptions().LockDuration(TimeSpan.FromMinutes(5));
    //            //transport.Queues().LockDuration(TimeSpan.FromMinutes(5));

    //            //// Routing for commands
    //            //foreach (var route in endpoint.Routes)
    //            //{
    //            //    routingForTransport.RouteToEndpoint(route.CommandType, route.Destination);
    //            //}

    ////            config.UseSerialization<NewtonsoftSerializer>();

    //            config.UseSerialization<NewtonsoftJsonSerializer>();

    //            config.EnableInstallers();

    //            config.AuditProcessedMessagesTo("audit", TimeSpan.FromDays(7));
    //            config.SendFailedMessagesTo("error");

    //           // SendErrorMessagesToSlackIfNeeded(config, configuration);

    //            return config;
    //        }

    //        //private static void SendErrorMessagesToSlackIfNeeded(
    //        //    EndpointConfiguration configuration,
    //        //    IConfiguration config)
    //        //{
    //        //    var shouldSend = config["SlackError:ShouldSend"];

    //        //    if (shouldSend == "true")
    //        //    {
    //        //        configuration.Notifications.Errors.MessageSentToErrorQueue += (o, m) =>
    //        //        {
    //        //            ErrorMessageNotifier.SendMessge(m, _logger, "CrossDomain.Integration");
    //        //        };
    //        //    }
    //        //}

    //        // ✅ REPLACEMENT FOR RoleEnvironment
    //        private static void LogEnvironmentInfo(ILogger logger)
    //        {
    //            try
    //            {
    //                logger.LogInformation($"Machine Name: {Environment.MachineName}");
    //                logger.LogInformation($"Process ID: {Environment.ProcessId}");
    //                logger.LogInformation($"App Name: {Environment.GetEnvironmentVariable("WEBSITE_SITE_NAME")}");
    //                logger.LogInformation($"Instance ID: {Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID")}");
    //            }
    //            catch (Exception e)
    //            {
    //                logger.LogWarning($"Environment info not available: {e.Message}");
    //            }
    //        }
    //    }
//}