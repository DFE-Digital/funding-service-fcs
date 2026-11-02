namespace OrganisationDomain.Web.IoC
{
    using System.Web.Http.Controllers;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Implementation.DataAccess;
    using Implementation.Mappers;
    using Integration.DataStore;
    using Services;
    using SFA.FCT.Framework.Logging.Bespoke;
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
                Classes.FromThisAssembly().BasedOn<IHttpController>().LifestyleTransient(),
                Component.For<ILocalOrganisationRetriever>().ImplementedBy<LocalOrganisationRetriever>().LifestylePerWebRequest(),
                Component.For<IOrganisationRepository>().ImplementedBy<OrganisationRepository>().LifestylePerWebRequest(),
                Component.For<ICpdsMapper>().ImplementedBy<CpdsMapper>().LifestyleSingleton(),
                Component.For<IOrganisationDomainDbContext>().ImplementedBy<OrganisationDomainDbContext>().LifestylePerWebRequest(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("OrgWebRole")));
        }
    }
}