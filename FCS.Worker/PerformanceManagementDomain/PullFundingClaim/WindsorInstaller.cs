namespace PerformanceManagementDomain.PullFundingClaim
{
    using System.Configuration;
    using Castle.MicroKernel;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using PerformanceManagementDomain.Services;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

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
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PerformanceManagementDomain")),
                Component.For<IFundingClaimsApiAdapter>().UsingFactoryMethod(GetFundingClaimsApiAdapter).LifestyleSingleton(),
                Component.For<IHttpService>().ImplementedBy<HttpService>().LifestyleSingleton(),
                Component.For<IOAuthAccessTokenFactory>().ImplementedBy<OAuthAccessTokenFactory>().LifestyleSingleton(),
                Component.For<IAzureTableStore>().ImplementedBy<AzureTableStore>().LifestyleSingleton(),
                Component.For<IEnvironmentContext>().ImplementedBy<EnvironmentContext>().LifestyleSingleton(),
                Component.For<IFundingClaimImportInfoRepository>().ImplementedBy<FundingClaimImportInfoRepository>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IClaimReconciliationBehaviourAsyncRepository>().ImplementedBy<ClaimReconciliationBehaviourAsyncRepository>().LifestyleSingleton(),
                Component.For<IFundingClaimRepository>().ImplementedBy<FundingClaimRepository>().LifestyleSingleton(),
                Component.For<IDateProvider>().ImplementedBy<DateProvider>().LifestyleSingleton(),
                Component.For<IClaimReconciliationAllocationGroupFspRepository>().ImplementedBy<ClaimReconciliationAllocationGroupFspRepository>().LifestyleSingleton(),
                Component.For<IFundingClaimDebatchService>().ImplementedBy<FundingClaimDebatchService>().LifestyleTransient(),
                Component.For<ReconciliationCalculationEndpoint.Repositories.IClaimReconciliationAllocationGroupFspRepository>().ImplementedBy<ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationAllocationGroupFspRepository>().LifestyleTransient()
            );
        }

        private static IFundingClaimsApiAdapter GetFundingClaimsApiAdapter(IKernel kernel)
        {
            bool useStub = bool.Parse(ConfigurationManager.AppSettings["DCT:FundingClaims:UseStub"]);

            if (useStub)
            {
                return new FundingClaimsApiStubAdapter(kernel.Resolve<IAzureTableStore>(), kernel.Resolve<IEnvironmentContext>());
            }

            return new FundingClaimsApiAdapter(kernel.Resolve<IHttpService>(), kernel.Resolve<IOAuthAccessTokenFactory>());
        }

    }
}
