namespace ContractCreateDomain.Endpoint.CreateProvidersIfNecessary
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.Implementation;
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
                Component.For<IXrmOrganisationManager>().ImplementedBy<XrmOrganisationManager>().LifestyleTransient(),
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped()
                );
        }
    }
}
