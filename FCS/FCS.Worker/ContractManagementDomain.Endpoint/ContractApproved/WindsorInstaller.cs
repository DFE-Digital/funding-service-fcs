namespace ContractManagementDomain.Endpoint.ContractApproved
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Services;
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
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleScoped(),
                Component.For<IApprovedContractAtomFeedItemCreationService>().ImplementedBy<ApprovedContractAtomFeedItemCreationService>().LifestyleSingleton(),
                Component.For<IApprovedContractAtomItemRepository>().ImplementedBy<ApprovedContractAtomItemRepository>().LifestyleSingleton(),
                Component.For<IContractTransformer>().ImplementedBy<ContractTransformer>().LifestyleSingleton(),
                Component.For<IApprovedContractPopulateCacheService>().ImplementedBy<ApprovedContractPopulateCacheService>().LifestyleSingleton(),
                Component.For<IApprovedContractRepository>().ImplementedBy<ApprovedContractRepository>().LifestyleSingleton(),
                Component.For<IFundingTypeFundingPeriodRepository>().ImplementedBy<FundingTypeFundingPeriodRepository>().LifestyleSingleton(),
                Component.For<IContractXmlValidator>().ImplementedBy<ContractXmlValidator>().LifestyleSingleton()
            );
        }
    }
}
