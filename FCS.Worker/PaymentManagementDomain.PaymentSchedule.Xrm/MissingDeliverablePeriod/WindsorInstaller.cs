namespace PaymentManagementDomain.PaymentSchedule.MissingDeliverablePeriod
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Infrastructure;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

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
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentManagementDomain")),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleScoped(),
                Component.For<IDeliverablePaymentCommandRepository>().ImplementedBy<DeliverablePaymentCommandRepository>().LifestyleSingleton()
            );
        }
    }
}
