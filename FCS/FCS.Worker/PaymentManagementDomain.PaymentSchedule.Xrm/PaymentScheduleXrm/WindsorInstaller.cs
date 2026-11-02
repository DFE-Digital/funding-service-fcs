namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Xrm.Infrastructure;

    public class WindsorInstaller : IWindsorInstaller
    {
        private readonly IWindsorInstaller _windsorInstaller;
        public WindsorInstaller(ILoggerFactory loggerFactory)
        {
            _windsorInstaller = new SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.IoC.WindsorInstaller(loggerFactory);
        }
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Install(_windsorInstaller);
            container.Register(Component.For<IOrganizationService>()
                .UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped());
            container.Register(Component.For<ISessionConnectionFactory>()
                .ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
            container.Register(Component.For<IProcessedMessageRepository>()
                .ImplementedBy<ProcessedMessageRepository>().LifestyleSingleton());
            container.Register(Component.For<IPaymentScheduleService>()
                .ImplementedBy<PaymentScheduleService>().LifestyleScoped());
            container.Register(Component.For<ICrmFspDeliverableRepository>()
                .ImplementedBy<CrmFspDeliverableRepository>().LifestyleScoped());
            container.Register(Component.For<ICrmDeliverableRepository>()
                .ImplementedBy<CrmDeliverableRepository>().LifestyleScoped());
            container.Register(Component.For<ICrmPeriodTypeRepository>()
                .ImplementedBy<CrmPeriodTypeRepository>().LifestyleScoped());
            container.Register(Component.For<ICrmTransactionRequestRepository>()
                .ImplementedBy<CrmTransactionRequestRepository>().LifestyleScoped());
        }
    }
}
