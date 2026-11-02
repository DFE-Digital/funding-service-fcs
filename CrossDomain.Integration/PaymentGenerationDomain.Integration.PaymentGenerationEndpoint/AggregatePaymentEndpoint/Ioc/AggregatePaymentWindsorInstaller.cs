namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint.Ioc
{
    using BusinessLogic;
    using BusinessLogic.Mappers;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Repositories;
    using Infrastructure;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public class AggregatePaymentWindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public AggregatePaymentWindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentGenerationDomain")));
            container.Register(
                Component.For<IDataAccessManager>().ImplementedBy<DataAccessManager>().LifestyleScoped());
            container.Register(
                Component.For<IAggregatedPaymentMapper>().ImplementedBy<AggregatedPaymentMapper>().LifestyleScoped());
            container.Register(Component.For<PaymentGenerationDbContext>().ImplementedBy<PaymentGenerationDbContext>().LifestyleScoped());
            container.Register(Component.For<IPaymentSchedulePolicyContext>().ImplementedBy<PaymentSchedulePolicyContext>().LifestyleScoped());
            container.Register(Component.For<ISubnominalAggregationRepository>()
                .ImplementedBy<SubnominalAggregationRepository>()
                .LifestyleScoped());
            container.Register(Component.For<IPaymentTimetableRepository>()
                .ImplementedBy<PaymentTimetableRepository>()
                .LifestyleScoped());
            container.Register(Component.For<IOutstandingPaymentsChecker>()
                .ImplementedBy<OutstandingPaymentsChecker>()
                .LifestyleScoped());
            container.Register(Component.For<Repositories.ISubnominalAggregationRepository>()
                    .ImplementedBy<Repositories.SubnominalAggregationRepository>()
                    .LifestyleScoped());
            container.Register(Component.For<IUpSertSubmoninalAggregationService>()
                    .ImplementedBy<UpSertSubmoninalAggregationService>()
                    .LifestyleScoped());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }
    }
}
