namespace FCT.Operations.FundingConfirmationReport
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Operations.Repositories;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly ILogger _logger;
        private readonly IFcsConfiguration _appConfiguration;

        public WindsorInstaller(ILogger logger, IFcsConfiguration appConfiguration)
        {
            _logger = logger;
            _appConfiguration = appConfiguration;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_logger),
                Component.For<IFcsConfiguration>().Instance(_appConfiguration),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IExcelReportGenerator>().ImplementedBy<ExcelGeneratorFundingConfirmationReport>().LifestyleSingleton(),
                Component.For<IReportService>().ImplementedBy<ReportService>().LifestyleSingleton(),
                Component.For<IlaReportService>().ImplementedBy<LAReportService>().LifestyleSingleton(),
                Component.For<IFundingConfirmationReportRepository>().ImplementedBy<FundingConfirmationReportRepository>().LifestyleSingleton(),
                Component.For<ILAFundingConfirmationReportRepository>().ImplementedBy<LAFundingConfirmationReportRepository>().LifestyleSingleton(),
                Component.For<IWorkbookSharePointRepository>().ImplementedBy<WorkbookSharePointRepository>().LifestyleSingleton(),
                Component.For<IOffice365StorageWrapper>().ImplementedBy<Office365StorageWrapper>().LifestyleSingleton(),
                Component.For<IAuthenticationHelper>().ImplementedBy<AuthenticationHelper>().LifestyleSingleton(),
                Component.For<ISharepointOAuthAccessTokenFactory>().ImplementedBy<SharepointOAuthAccessTokenFactory>().LifestyleSingleton()
                          );
        }
    }
}
