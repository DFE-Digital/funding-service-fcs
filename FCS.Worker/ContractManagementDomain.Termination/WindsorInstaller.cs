namespace ContractManagementDomain.Termination
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.Repositories;
    using ContractManagementDomain.Termination.Services;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Repositories;
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
                Component.For<ILogger>().Instance(_loggerFactory.CreateDefaultLogger()),
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleScoped(),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleTransient(),
                Component.For<ILegalDeliverableService>().ImplementedBy<LegalDeliverableService>().LifestyleScoped(),
                Component.For<IApprovalOnwardsContractAtomFeedService>().ImplementedBy<ApprovalOnwardsContractAtomFeedService>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodLegalDeliverableRepository>().ImplementedBy<FundingStreamPeriodLegalDeliverableRepository>().LifestyleScoped(),
                Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped(),
                Component.For<IApprovalOnwardsContractAtomItemRepository>().ImplementedBy<ApprovalOnwardsContractAtomItemRepository>().LifestyleScoped(),
                Component.For<IContractTransformer>().ImplementedBy<ContractTransformer>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<ICrmTerminationContractRepository>().ImplementedBy<CrmTerminationContractRepository>().LifestyleScoped(),
                Component.For<ITerminateContractValidationService>().ImplementedBy<TerminateContractValidationService>().LifestyleSingleton(),
                Component.For<ITerminateContractInfoCreator>().ImplementedBy<TerminateContractInfoCreator>().LifestyleScoped(),
                Component.For<IMonthEndHistoryRepository>().ImplementedBy<MonthEndHistoryRepository>().LifestyleScoped(),
                Component.For<IApprovedContractRepository>().ImplementedBy<ApprovedContractRepository>().LifestyleScoped(),
                Component.For<IDateProvider>().ImplementedBy<DateProvider>().LifestyleSingleton(),
                Component.For<ICorporateContractService>().ImplementedBy<CorporateContractService>().LifestyleScoped(),
                Component.For<IContractXmlValidator>().ImplementedBy<ContractXmlValidator>().LifestyleSingleton(),
                Component.For<ITerminateContractFeedService>().ImplementedBy<TerminateContractFeedService>().LifestyleScoped());
        }
    }
}