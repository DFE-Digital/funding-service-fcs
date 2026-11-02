namespace PerformanceManagementDomain.XrmEndpoint
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using SFA.FCS.Worker.Common.Crm;
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
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PerformanceManagementDomain")));

            container.Register(Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped());
            container.Register(Component.For<IFundingClaimReconciliationCommandRepository>().ImplementedBy<FundingClaimReconciliationCommandRepository>().LifestyleTransient());
        }
    }
}