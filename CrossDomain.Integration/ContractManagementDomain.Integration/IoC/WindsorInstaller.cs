namespace SFA.FCT.ContractManagementDomain.Integration.IoC
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractCreateDomain.Implementation.Persistence;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementService.Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore;
    using Framework.Logging.Interfaces;
    using System.Configuration;
    using CrossDomain.Integration.Entities.Data;
    using Infrastructure;
    using PublishContractWithdrawalEndpoint;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public string CrmConnectionString { get; set; }

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
            CrmConnectionString = ConfigurationManager.ConnectionStrings["CrmConnectionString"]?.ConnectionString;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<IApprovedContractAtomItemRepository>().ImplementedBy<ApprovedContractAtomItemRepository>().LifestyleScoped());
            container.Register(Component.For<IDraftContractAtomItemRepository>().ImplementedBy<DraftContractAtomItemRepository>().LifestyleScoped());
            container.Register(Component.For<IWithdrawnContractAtomItemRepository>().ImplementedBy<WithdrawnContractAtomItemRepository>().LifestyleScoped());
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain")));
            container.Register(Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>());
            container.Register(Component.For<IStorageObjectSerializer>().ImplementedBy<StorageObjectSerializer>());
            container.Register(Component.For<IContractTransformer>().ImplementedBy<ContractTransformer>().LifestyleSingleton());
            container.Register(Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>().LifestyleSingleton());
            container.Register(Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleTransient());
            container.Register(Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped());
            container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped());
            container.Register(Component.For<IMonthEndHistoryRepository>().ImplementedBy<MonthEndHistoryRepository>().LifestyleScoped());
            container.Register(Component.For<IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<FundingTypeFundingPeriodQueryRepository>().LifestyleScoped());
            container.Register(Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped()); // todo: this may but probably won't work for all
            container.Register(
                Component.For(typeof (IEntityCache<,>)).ImplementedBy(typeof (EntityCache<,>)).LifestyleSingleton());
            container.Register(Component.For<IApprovedContractRepository>().ImplementedBy<ApprovedContractRepository>().LifestyleScoped());
            container.Register(Component.For<IContractXmlValidator>().ImplementedBy<ContractXmlValidator>().LifestyleSingleton());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
            
        }
    }
}
