namespace PerformanceManagementDomain.ReconciliationPublication
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Repositories;

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
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IFcrPublisher>().ImplementedBy<FcrPublisher>().LifestyleSingleton(),
                Component.For<IAtomFeedItemRepository>().ImplementedBy<AtomFeedItemRepository>().LifestyleSingleton(),
                Component.For<IDateProvider>().ImplementedBy<DateProvider>().LifestyleSingleton(),
                Component.For<IClaimReconciliationBehaviourRepository>().ImplementedBy<ClaimReconciliationBehaviourRepository>().LifestyleSingleton(),
                Component.For<IFundingClaimReconciliationQueryRepository>().ImplementedBy<FundingClaimReconciliationQueryRepository>().LifestyleScoped(),
                Component.For<IClaimReconciliationPublicationExceptionRepository>().ImplementedBy<ClaimReconciliationPublicationExceptionRepository>().LifestyleSingleton(),
                Component.For<IClaimReconciliationReferenceDataReconProfilingRepository>().ImplementedBy<ClaimReconciliationReferenceDataReconProfilingRepository>().LifestyleSingleton()
                );
        }
    }
}
