namespace FCT.Operations.Cda.ReportGeneration
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using ReportUpload;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCS.Worker.Common;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILogger _logger;
        private readonly IFcsConfiguration _configuration;

        public WindsorInstaller(ILogger logger, IFcsConfiguration configurationRoot)
        {
            _logger = logger;
            _configuration = configurationRoot;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_logger));
            container.Register(
                Component.For<IFcsConfiguration>().Instance(_configuration));
            container.Register(Component.For<IAuthenticationHelper>().ImplementedBy<AuthenticationHelper>().LifestyleSingleton());
            container.Register(Component.For<ISharepointOAuthAccessTokenFactory>().ImplementedBy<SharepointOAuthAccessTokenFactory>().LifestyleSingleton());
            container.Register(Component.For<ICrmCdaRepository>().ImplementedBy<CrmCdaRepository>().LifestyleSingleton());
            container.Register(Component.For<ICdaConfigRepository>().ImplementedBy<CdaConfigRepository>().LifestyleSingleton());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
            container.Register(Component.For<IOverrideDateRepository>().ImplementedBy<OverrideDateRepository>().LifestyleSingleton());
            container.Register(Component.For<IArchiveFolderCreator>().ImplementedBy<ArchiveFolderCreator>().LifestyleSingleton());
            container.Register(Component.For<IOffice365StorageWrapper>().ImplementedBy<Office365StorageWrapper>().LifestyleSingleton());
            container.Register(Component.For<IProcessedMessageRepository>().ImplementedBy<ProcessedMessageRepository>().LifestyleSingleton());
            container.Register(Component.For<IReportUploadService>().ImplementedBy<ReportUploadService>().LifestyleSingleton());
            container.Register(Component.For<IReportCreationService>().ImplementedBy<ReportCreationService>().LifestyleSingleton());
            container.Register(Component.For<IClosedContractRepository>().ImplementedBy<ClosedContractRepository>().LifestyleSingleton());
            container.Register(Component.For<IClosedReportService>().ImplementedBy<ClosedReportService>().LifestyleSingleton());
        }
    }
}
