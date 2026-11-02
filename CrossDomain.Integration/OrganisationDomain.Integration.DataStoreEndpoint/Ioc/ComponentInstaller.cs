namespace OrganisationDomain.Integration.DataStoreEndpoint.Ioc
{
    using System;
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using DataStore;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Implementation.Mappers;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ILoggerFactory = SFA.FCT.Framework.Logging.Interfaces.ILoggerFactory;

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
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("OrganisationDomainDataStoreEndpoint")),
                GetCpdsOrganisationRetriever(),
                Component.For<GatewayServiceContract>().ImplementedBy<GatewayServiceContractClient>().LifeStyle.Transient,
                Component.For<Func<GatewayServiceContract>>().Instance(container.Resolve<GatewayServiceContract>),
                Component.For<ICpdsMapper>().ImplementedBy<CpdsMapper>().LifestyleSingleton(),
                Component.For<ICpdsXmlValidator>().ImplementedBy<CpdsXmlValidator>().LifestyleSingleton(),
                Component.For<IOrganisationDomainDbContext>().ImplementedBy<OrganisationDomainDbContext>().LifestyleScoped(),
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
