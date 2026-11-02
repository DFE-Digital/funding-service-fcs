namespace SFA.FCT.ContractManagementService.IoC
{
    using AtomFeed;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Common.PagedStorage.Repositories;
    using CrossDomain.Integration.Common.Repositories;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using global::ContractManagementService.Repositories;
    using global::ContractManagementService.Services;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using PerformanceManagementDomain.DataStore;
    using PerformanceManagementDomain.DataStore.Repositories.Atom;
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;


    public class IoCSetup
    {
        private readonly ILogger _logger;
        public static IFcsConfiguration FcsConfiguration;

        public IoCSetup(ILogger logger)
        {
            _logger = logger;
        }

        public void Register(IServiceCollection serviceCollection, IConfiguration configuration)
        {
            FcsConfiguration = new LocalFcsConfiguration(configuration);
            serviceCollection.AddSingleton(typeof(ILogger), _logger);
            serviceCollection.AddSingleton(typeof(AtomFeed.IAtomFeedGenerator<>),
                typeof(AtomFeed.AtomFeedGenerator<>));
            serviceCollection.AddScoped<SqlConnection>(serviceProvider => new SqlConnection(configuration["ConnectionStrings:ContractManagementDbContext"]));
            serviceCollection.AddTransient<IAtomFeedItemQueryRepository, AtomFeedItemQueryRepository>();
            serviceCollection.AddSingleton(typeof(IFcsConfiguration), FcsConfiguration);
            serviceCollection.AddTransient<IPageNumberMutator, AllocationFeedPageNumberMutator>();
            serviceCollection.AddTransient<IAllocationDeliveryEntryQueryRepository, AllocationDeliveryEntryQueryRepository>();
            serviceCollection.AddSingleton<IPagedStorageRepository<DeliverableSettingConfiguration>, AzureDeliverableSettingConfigurationRepository>();            
            serviceCollection.AddTransient<IPaymentBatchFeedItemRepository, PaymentBatchFeedItemRepository>();
            serviceCollection.AddSingleton<IDapperQueryExecutor, DapperQueryExecutor>();
            serviceCollection.AddTransient<IAllocationFundingStreamPeriodCodeQueryRepository, AllocationFundingStreamPeriodCodeQueryRepository>();
            serviceCollection.AddTransient<IFundingStreamPeriodCodeService, FundingStreamPeriodCodeService>();
            serviceCollection.AddSingleton<IEnvironmentContext, EnvironmentContext>();
            serviceCollection.AddSingleton<IAzureTableStore, AzureTableStore>();
            serviceCollection.AddSingleton<IStorageObjectSerializer, StorageObjectSerializer>();
            serviceCollection.AddTransient<IApprovedContractAtomItemRepository, ApprovedContractAtomItemRepository>();
            serviceCollection.AddTransient<IDraftContractAtomItemRepository, DraftContractAtomItemRepository>();
            serviceCollection.AddTransient<IAllContractAtomItemRepository, AllContractAtomItemRepository>();
            //serviceCollection.AddTransient<PaymentGenerationDbContext>(); // this may not work
            serviceCollection.AddTransient<IApprovalOnwardsContractAtomItemRepository, ApprovalOnwardsContractAtomItemRepository>();
            serviceCollection.AddTransient<IWithdrawnContractAtomItemRepository, WithdrawnContractAtomItemRepository>();
            serviceCollection.AddSingleton<ICrmConfigurationRepository, CrmConfigurationRepository>();
            serviceCollection.AddSingleton<IPagedStorageQueryRepository<DeliverableSettingConfiguration>, PagedStorageQueryRepository<DeliverableSettingConfiguration>>();
            serviceCollection.AddSingleton<IAzureTableStorageRepository, AzureTableStorageRepository>();

            // ✅ Add this BEFORE typeWithImplementations

            serviceCollection.AddScoped<PerformanceManagementDbContext>(sp =>
            {
                var conn = configuration.GetConnectionString("PerformanceManagementDbContext")
                           ?? configuration["ConnectionStrings:PerformanceManagementDbContext"];

                if (string.IsNullOrWhiteSpace(conn))
                {
                    throw new Exception("PerformanceManagementDbContext connection string is missing");
                }

                return new PerformanceManagementDbContext(new SqlConnection(conn));
            });

            var typeWithImplementations = new List<(Type serviceType, object implementation)>(ContractManagementIoCHelper.GetTypesWithImplementations(FcsConfiguration));

            typeWithImplementations.AddRange(PerformanceManagementIoCHelper.GetTypesWithImplementations(FcsConfiguration));

            typeWithImplementations.ToList().ForEach(t =>
            {
                serviceCollection.AddSingleton(t.serviceType, t.implementation);
            });
        }

        private class LocalFcsConfiguration : IFcsConfiguration
        {
            private readonly IConfiguration _configuration;

            public LocalFcsConfiguration(IConfiguration configuration)
            {
                _configuration = configuration;
            }

            public string this[string key] => _configuration[key];
        }
    }
}