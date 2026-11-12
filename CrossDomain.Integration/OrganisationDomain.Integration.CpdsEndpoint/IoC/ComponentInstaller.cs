namespace OrganisationDomain.Integration.CpdsEndpoint.Ioc
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Implementation.Mappers;
    using OrganisationDomain.Implementation.ExternalServices.Helper;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;

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
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("OrganisationDomainCpdsEndpoint")),
                GetCpdsSummaryRetriever(),
                Component.For<ICpdsProviderConverter>().ImplementedBy<CpdsProviderConverter>().LifestyleSingleton(),
                GetCpdsOrganisationRetriever(),
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>().LifestyleSingleton(),
            // Component.For<GatewayServiceContract>().ImplementedBy<GatewayServiceContractClient>().LifestyleTransient(),
                Component.For<GatewayServiceContract>().UsingFactoryMethod(() =>  GatewayServiceClientFactory.Create()).LifestyleTransient(),                        
                Component.For<ICpdsMapper>().ImplementedBy<CpdsMapper>().LifestyleSingleton(),
                Component.For<ICpdsXmlValidator>().ImplementedBy<CpdsXmlValidator>().LifestyleSingleton());
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
