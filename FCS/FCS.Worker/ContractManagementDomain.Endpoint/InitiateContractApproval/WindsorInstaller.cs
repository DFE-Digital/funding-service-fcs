namespace ContractManagementDomain.Endpoint.InitiateContractApproval
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Repositories;
    using Endpoint.Services;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain")),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IMonthEndHistoryRepository>().ImplementedBy<MonthEndHistoryRepository>().LifestyleScoped(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped(),
                Component.For<IContractCheckerService>().ImplementedBy<ContractCheckerService>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodQueryRepository>().ImplementedBy<FundingTypeFundingPeriodQueryRepository>().LifestyleScoped(),
                Component.For(typeof(IEntityCache<,>)).ImplementedBy(typeof(EntityCache<,>)).LifestyleSingleton(),
                Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleScoped(),
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<IDateProvider>().ImplementedBy<DateProvider>().LifestyleSingleton(),
                Component.For<ICrmContractDeliverablePeriodRepository>().ImplementedBy<CrmContractDeliverablePeriodRepository>().LifestyleScoped(),
                Component.For<ICrmContractAllocationRepository>().ImplementedBy<CrmContractAllocationRepository>().LifestyleScoped(),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleScoped(),
                Component.For<IFundingTypeFundingPeriodService>().ImplementedBy<FundingTypeFundingPeriodService>().LifestyleScoped(),
                Component.For<IXrmManager>().ImplementedBy<XrmManager>().LifestyleScoped()
                );
        }
    }
}
