namespace OrganisationDomain.Integration.MainEndpoint.Ioc
{
    using System;
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Castle.Windsor.Installer;
    using Implementation.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [ExcludeFromCodeCoverage]
    public static class Bootstrapper
    {
        public static IWindsorContainer CreateContainer(ILoggerFactory factory)
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(
                    FromAssembly.Named("OrganisationDomain.Integration.DataStore"),
                    FromAssembly.Named("OrganisationDomain.Implementation"),
                    new ComponentInstaller(factory));
            container.Register(GetOrgSupplementaryDataServiceRegistration().IsDefault());

            return container;
        }

        private static ComponentRegistration<IOrgSupplementaryDataService> GetOrgSupplementaryDataServiceRegistration()
        {
            var useRealUkrlpService = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealUkrlpService"]);

            if (useRealUkrlpService)
            {
                return Component.For<IOrgSupplementaryDataService>().ImplementedBy<OrgSupplementaryDataService>().LifestyleSingleton();
            }

            return Component.For<IOrgSupplementaryDataService>().ImplementedBy<OrgSupplementaryDataServiceTestImpl>().LifestyleSingleton();
        }
    }
}
