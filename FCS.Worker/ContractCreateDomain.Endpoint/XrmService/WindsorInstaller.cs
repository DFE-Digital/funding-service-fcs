namespace ContractCreateDomain.Endpoint.XrmService
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
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
                Component.For<IXrmAllocationEvidenceManager>().ImplementedBy<XrmAllocationEvidenceManager>().LifestyleScoped(),
                Component.For<IFundingStreamDeliverablePeriodRepository>().ImplementedBy<FundingStreamDeliverablePeriodRepository>().LifestyleSingleton(),
                Component.For<IContractsManager>().ImplementedBy<ContractsManager>().LifestyleScoped(),
                Component.For<ILookupManager>().ImplementedBy<LookupManager>().LifestyleScoped(),
                Component.For<IXrmOrganisationManager>().ImplementedBy<XrmOrganisationManager>().LifestyleScoped(),
                Component.For<IXrmWorkflowManager>().ImplementedBy<XrmWorkflowManager>().LifestyleScoped(),
                Component.For<IBatchCacheManager>().ImplementedBy<BatchCacheManager>().LifestyleSingleton(),
                Component.For<IEnduringCacheManager>().ImplementedBy<EnduringCacheManager>().LifestyleSingleton(),
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<IProcessedMessageRepository>().ImplementedBy<ProcessedMessageRepository>().LifestyleSingleton(),
                Component.For<IContractQueryRepository>().ImplementedBy<ContractQueryRepository>().LifestyleScoped(),
                Component.For<IContractDeDuplicationService>().ImplementedBy<ContractDeDuplicationService>().LifestyleScoped(),
                Component.For<IContractAllocationCommandRepository>().ImplementedBy<ContractAllocationRepository>().LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }
    }
}
