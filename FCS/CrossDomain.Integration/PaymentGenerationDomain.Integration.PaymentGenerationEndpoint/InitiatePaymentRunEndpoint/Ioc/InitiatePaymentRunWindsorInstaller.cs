namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentRunEndpoint.Ioc
{
    using BusinessLogic;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Repositories;
    using Infrastructure;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class InitiatePaymentRunWindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public InitiatePaymentRunWindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentGenerationDomain")));
            container.Register(Component.For<IDataAccessManager>().ImplementedBy<DataAccessManager>().LifestyleScoped());
            container.Register(Component.For<PaymentGenerationDbContext>().ImplementedBy<PaymentGenerationDbContext>().LifestyleScoped());
            container.Register(Component.For<ISubnominalAggregationRepository>()
                .ImplementedBy<SubnominalAggregationRepository>()
                .LifestyleScoped());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }
    }
}
