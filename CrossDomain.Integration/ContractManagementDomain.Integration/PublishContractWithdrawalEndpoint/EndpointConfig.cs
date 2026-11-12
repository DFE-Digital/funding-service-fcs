
namespace SFA.FCT.ContractManagementDomain.Integration.PublishContractWithdrawalEndpoint
{
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Events;
    using FCS.Worker.Common;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.Extensions.Logging;
    using NServiceBus;
    using ContractCreateDomain.Implementation.Persistence;
    using ContractManagementService.Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore;
    using CrossDomain.Integration.Entities.Data;
    using Infrastructure;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class EndpointConfig : IEndpointConfig
    {
        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(ContractWithdrawnEvent)
        };

        public string NameOfAssembly => "ContractManagementDomain.Integration.dll";

        public string EndpointName => "ContractManagementDomain.PublishContractWithdrawal";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("ContractManagementDomain.InitiateContractWithdrawal", typeof(ContractWithdrawnEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.IncrementContractVersion", typeof(IncrementContractVersionCommand))
        };


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

            // ✅ Conventions (recommended standard)
            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    typeof(ICommand).IsAssignableFrom(t))
                .DefiningEventsAs(t =>
                    EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

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
                // Scoped (LifestyleScoped)
                // -----------------------------
                services.AddScoped<IApprovedContractAtomItemRepository, ApprovedContractAtomItemRepository>();
                services.AddScoped<IDraftContractAtomItemRepository, DraftContractAtomItemRepository>();
                services.AddScoped<IWithdrawnContractAtomItemRepository, WithdrawnContractAtomItemRepository>();
                services.AddScoped<IOverrideDateDBContext, OverrideDateDBContext>();
                services.AddScoped<IMonthEndHistoryRepository, MonthEndHistoryRepository>();
                services.AddScoped<IFundingTypeFundingPeriodQueryRepository, FundingTypeFundingPeriodQueryRepository>();
                services.AddScoped<IContractManagementDbContext, ContractManagementDbContext>();
                services.AddScoped<IDate, StaticDate>();
                services.AddScoped<IApprovedContractRepository, ApprovedContractRepository>();

                // -----------------------------
                // Transient (LifestyleTransient)
                // -----------------------------
                services.AddTransient<IContractsManager, ContractsManager>();
                services.AddTransient<IAzureTableStore, AzureTableStore>();
                services.AddTransient<IStorageObjectSerializer, StorageObjectSerializer>();

                // -----------------------------
                // Singleton
                // -----------------------------
                services.AddSingleton<IContractTransformer, ContractTransformer>();
                services.AddSingleton<IEnvironmentContext, EnvironmentContext>();
                services.AddSingleton<IContractXmlValidator, ContractXmlValidator>();
                services.AddSingleton<ISessionConnectionFactory, SessionConnectionFactory>();

                // -----------------------------
                // Open generic
                // -----------------------------
                services.AddSingleton(typeof(IEntityCache<,>), typeof(EntityCache<,>));
            });

            return configuration;
        }

    }
}