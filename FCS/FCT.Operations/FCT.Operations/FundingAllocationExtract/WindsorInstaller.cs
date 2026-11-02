namespace FCT.Operations.FundingAllocationExtract
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Repositories;
    using Infrastructure;
    using FCT.Operations.Repositories;
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
            container
                .Register(Component.For<ILogger>().Instance(_logger))
                .Register(Component.For<IFcsConfiguration>().Instance(_appConfiguration))
                .Register(Component.For<IWorkbookSharePointRepository>().ImplementedBy<WorkbookSharePointRepository>()
                    .LifestyleSingleton())
                .Register(Component.For<IExcelGenerator>().ImplementedBy<ExcelGenerator>().LifestyleSingleton())
                .Register(Component.For<IFundingAllocationExtractRepository>()
                    .ImplementedBy<FundingAllocationExtractRepository>().LifestyleSingleton())
                .Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>()
                    .LifestyleSingleton())
                .Register(Component.For<IOffice365StorageWrapper>().ImplementedBy<Office365StorageWrapper>().LifestyleSingleton())
                .Register(Component.For<IAuthenticationHelper>().ImplementedBy<AuthenticationHelper>().LifestyleSingleton())
                .Register(Component.For<ISharepointOAuthAccessTokenFactory>().ImplementedBy<SharepointOAuthAccessTokenFactory>().LifestyleSingleton());
        }
    }
}
