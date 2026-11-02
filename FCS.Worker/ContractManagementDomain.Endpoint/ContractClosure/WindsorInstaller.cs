namespace ContractManagementDomain.Endpoint.ContractClosure
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
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
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IDateProvider>().ImplementedBy<DateProvider>().LifestyleSingleton(),
                Component.For<IApprovedContractRepository>().ImplementedBy<ApprovedContractRepository>().LifestyleScoped(),
                Component.For<IApprovedContractAllocationRepository>().ImplementedBy<ApprovedContractAllocationRepository>().LifestyleScoped(),
                Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleScoped(),
                Component.For<IMonthEndHistoryRepository>().ImplementedBy<MonthEndHistoryRepository>().LifestyleScoped(),
                Component.For<IValidationService>().ImplementedBy<ValidationService>().LifestyleScoped(),
                Component.For<IApprovalOnwardsContractAtomItemRepository>().ImplementedBy<ApprovalOnwardsContractAtomItemRepository>().LifestyleScoped(),
                Component.For<IContractTransformer>().ImplementedBy<ContractTransformer>().LifestyleSingleton(),
                Component.For<IApprovalOnwardsContractAtomFeedService>().ImplementedBy<ApprovalOnwardsContractAtomFeedService>().LifestyleScoped(),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleScoped(),
                Component.For<ILegalDeliverableService>().ImplementedBy<LegalDeliverableService>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodLegalDeliverableRepository>().ImplementedBy<FundingStreamPeriodLegalDeliverableRepository>().LifestyleScoped(),
                Component.For<IContractXmlValidator>().ImplementedBy<ContractXmlValidator>().LifestyleSingleton(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped()
                );
        }
    }
}
