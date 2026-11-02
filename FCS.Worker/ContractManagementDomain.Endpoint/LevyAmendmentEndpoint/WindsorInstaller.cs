namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Repositories;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService())
                .LifestyleScoped());
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain")).LifestyleSingleton());
            container.Register(Component.For<IRoatpProviderRepository>().ImplementedBy<RoatpProviderRepository>().LifestyleSingleton());
            container.Register(Component.For<IRoatpApiHttpClient>().ImplementedBy<RoatpApiHttpClient>().LifestyleSingleton());
            container.Register(Component.For<IRoatpRepositoryService>().ImplementedBy<RoatpRepositoryService>().LifestyleSingleton());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
            container.Register(Component.For<IAmendLevyContractService>().ImplementedBy<AmendLevyContractService>().LifestyleScoped());
            container.Register(Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleScoped());
        }
    }
}