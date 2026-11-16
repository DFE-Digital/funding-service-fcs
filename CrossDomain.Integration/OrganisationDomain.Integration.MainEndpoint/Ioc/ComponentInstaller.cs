namespace OrganisationDomain.Integration.MainEndpoint.Ioc
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Repositories;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Implementation.Mappers;
    using Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using OrganisationDomain.Implementation.ExternalServices.Helper;

    [ExcludeFromCodeCoverage]
    public class ComponentInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public ComponentInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            string ukrlpServiceUrl = ConfigurationManager.AppSettings["UkrlpService:Url"];
            
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("OrganisationDomainEndpoint")),
                Component.For<IOrganisationRepository>().ImplementedBy<OrganisationRepository>().LifestyleScoped(),
                Component.For<IOrgSupplementaryPopulationService>().ImplementedBy<OrgSupplementaryPopulationService>().LifestyleScoped(),
                //Component.For<ProviderQueryServiceV5>().UsingFactoryMethod(k => new ProviderQueryServiceV5 {Url = ukrlpServiceUrl}).LifestyleScoped(),
                Component.For<IOrgSupplementaryChangeService>().ImplementedBy<OrgSupplementaryChangeService>().LifestyleScoped(),
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>().LifestyleSingleton(),
                Component.For<IOrganisationDomainDbContext>().ImplementedBy<OrganisationDomainDbContext>().LifestyleScoped(),
                GetCpdsOrganisationRetriever(),
                //Component.For<GatewayServiceContract>().ImplementedBy<GatewayServiceContractClient>().LifeStyle.Transient,
                Component.For<GatewayServiceContract>().UsingFactoryMethod(() => GatewayServiceClientFactory.Create()).LifestyleTransient(),
                Component.For<Func<GatewayServiceContract>>().Instance(container.Resolve<GatewayServiceContract>),
                Component.For<ICpdsMapper>().ImplementedBy<CpdsMapper>().LifestyleSingleton(),
                Component.For<ICpdsXmlValidator>().ImplementedBy<CpdsXmlValidator>().LifestyleSingleton(),
                Component.For<Implementation.DataAccess.IOrganisationRepository>().ImplementedBy<Implementation.DataAccess.OrganisationRepository>().LifestyleScoped(),
                Component.For<IProviderResolver>().ImplementedBy<ProviderResolver>().LifestyleScoped(),
                Component.For<IProviderComparer>().ImplementedBy<ProviderComparer>().LifestyleScoped(),
                GetCpdsSummaryRetriever(),
                Component.For<ICpdsProviderConverter>().ImplementedBy<CpdsProviderConverter>().LifestyleSingleton());
        }

        private static IRegistration GetCpdsSummaryRetriever()
        {
            string useStubForCPDS = ConfigurationManager.AppSettings["CPDS:UseStub"];
            if (useStubForCPDS == "true")
            {
                return Component.For<ICpdsSummaryRetriever>().ImplementedBy<CpdsStub>().Named("ICpdsSummaryRetrieverStub")
                    .LifestyleSingleton();
            }

            return Component.For<ICpdsSummaryRetriever>().ImplementedBy<CpdsSummaryRetriever>()
                .LifestyleSingleton();
        }

        private static IRegistration GetCpdsOrganisationRetriever()
        {
            string useStubForCPDS = ConfigurationManager.AppSettings["CPDS:UseStub"];
            if (useStubForCPDS == "true")
            {
                return Component.For<ICpdsOrganisationRetriever>().ImplementedBy<CpdsStub>().Named("ICpdsOrganisationRetrieverStub")
                    .LifestyleSingleton();
            }

            return Component.For<ICpdsOrganisationRetriever>().ImplementedBy<CpdsOrganisationRetriever>()
                .LifestyleSingleton();
        }
    }
}
 