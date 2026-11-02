namespace ContractCreateDomain.Endpoint.EnrichForDocumentation
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Services;
    using Services.Repositories;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
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
                Component.For<IOrganisationService>().ImplementedBy<OrganisationService>().LifestyleSingleton(),
                Component.For<IOrganisationServiceApiHttpClient>().ImplementedBy<OrganisationServiceApiHttpClient>().LifestyleSingleton(),
                Component.For<ISiblingApprovedContractService>().ImplementedBy<SiblingApprovedContractService>().LifestyleSingleton(),
                Component.For<IApprovedContractRepository>().ImplementedBy<ApprovedContractRepository>().LifestyleSingleton(),
                Component.For<IFundingTypeFundingPeriodRepository>().ImplementedBy<FundingTypeFundingPeriodRepository>().LifestyleSingleton(),
                Component.For<IRelatedAllocationEnricher>().ImplementedBy<RelatedAllocationEnricher>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IContractEnrichmentService>().ImplementedBy<ContractEnrichmentService>().LifestyleSingleton());
        }
    }
}
