namespace DocumentsDomain.Endpoint.ArchiveDocument
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Infrastructure;
    using Repositories;

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
                Component.For<IArchiveFileOrchestrator>().ImplementedBy<ArchiveFileOrchestrator>().LifestyleSingleton(),
                Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleSingleton(),
                Component.For<IArchivedDocumentRepository>().ImplementedBy<ArchivedDocumentRepository>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleScoped(),
                Component.For<IPolicyQueryService>().ImplementedBy<PolicyQueryService>().LifestyleSingleton());
        }
    }
}
