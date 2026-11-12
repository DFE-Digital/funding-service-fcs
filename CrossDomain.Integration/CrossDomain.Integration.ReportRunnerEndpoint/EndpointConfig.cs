namespace CrossDomain.Integration.ReportRunnerEndpoint
{
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.ReportRunnerEndpoint.Services;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        public string NameOfAssembly => "CrossDomain.Integration.ReportRunnerEndpoint.dll";

        public string EndpointName => "CrossDomain.Integration.ReportRunnerEndpoint";

        public IReadOnlyCollection<Subscription> Subscriptions => new[]
        {
            new Subscription("Operations.Cda.ReportGeneration", typeof(RunReportsAndArchiveExistingCommand)),
            new Subscription("AllocationDeliveryDomain.MonthEndCheck", typeof(MonthEndCompletedEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();


        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            var connectionString = Environment.GetEnvironmentVariable("AzureServiceBusConnection");

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException(
                    "AzureServiceBusConnection environment variable is not set.");
            }

            // ✅ Transport
            configuration.UseTransport(
                new AzureServiceBusTransport(
                    connectionString,
                    TopicTopology.Default));

            configuration.UsePersistence<LearningPersistence>();

            configuration.EnableInstallers();

            configuration.Recoverability()
                .Immediate(i => i.NumberOfRetries(3))
                .Delayed(d => d.NumberOfRetries(3));

            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    Subscriptions.Any(s => s.EventType.IsAssignableFrom(t)));

            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ INLINE Windsor replacement
            configuration.RegisterComponents(services =>
            {
                // -----------------------------
                // Logging
                // -----------------------------
                services.AddSingleton(loggerFactory);

                services.AddSingleton<ILogger>(
                   _ => loggerFactory.CreateLogger<EndpointConfig>());

                // -----------------------------
                // Transient services
                // -----------------------------
                services.AddTransient<IReportRunner, ReportRunner>();
                services.AddTransient<IOffice365Adapter, Office365StorageWrapper>();

                // -----------------------------
                // Singleton services
                // -----------------------------
                services.AddSingleton<IArchiveReportService, ArchiveReportService>();

                // -----------------------------
                // Scoped services
                // -----------------------------
                services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
                services.AddScoped<ICdaReportFundingStreamPeriodQueryRepository, CdaReportFundingStreamPeriodQueryRepository>();
                services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();

                // -----------------------------
                // ParseDateRegistration replacement
                // -----------------------------
                var useRealDate = Convert.ToBoolean(
                    Environment.GetEnvironmentVariable("UseRealDate") ?? "false");

                if (useRealDate)
                {
                    services.AddScoped<IDate, SystemDate>();
                }
                else
                {
                    services.AddScoped<IDate, StaticDate>();
                }
            });

            return configuration;
        }

    }
}
