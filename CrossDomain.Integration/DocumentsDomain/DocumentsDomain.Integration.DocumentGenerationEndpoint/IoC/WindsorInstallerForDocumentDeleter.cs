namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using CrossDomain.Integration.Common.Storage;
    using DocumentGeneration.DocumentDeleter;
    using DocumentGeneration.DocumentLocationResolver;
    using Framework.Logging.Interfaces;

    public class WindsorInstallerForDocumentDeleter : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public WindsorInstallerForDocumentDeleter(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<IDocumentDeleter>().ImplementedBy<DocumentDeleter>().LifestyleSingleton(),
                Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleSingleton(),
                Component.For<IDocumentLocationResolver>().ImplementedBy<DocumentLocationResolver>().LifestyleSingleton(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("DocumentsDomain")));
        }
    }
}
