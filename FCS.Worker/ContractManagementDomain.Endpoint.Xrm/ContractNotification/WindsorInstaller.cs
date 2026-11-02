namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
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
            container.Register(Component.For<IOrganizationService>()
                .UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped());
            container.Register(Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("ContractManagementDomain")).LifestyleSingleton());
            container.Register(Component.For<ICrmContractRepository>().ImplementedBy<CrmContractRepository>().LifestyleScoped());
            container.Register(Component.For<ICrmNotificationRepository>().ImplementedBy<CrmNotificationRepository>().LifestyleScoped());
            container.Register(Component.For<ICrmNotificationService>().ImplementedBy<CrmNotificationService>().LifestyleScoped());
        }
    }
}