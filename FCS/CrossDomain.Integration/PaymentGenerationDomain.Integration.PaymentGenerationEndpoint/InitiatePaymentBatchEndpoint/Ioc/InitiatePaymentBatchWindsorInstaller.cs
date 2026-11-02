namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint.Ioc
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging.Interfaces;
    using BusinessLogic;
    using DataStore;
    using DataStore.Repositories;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;

    public class InitiatePaymentBatchWindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public InitiatePaymentBatchWindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentGenerationDomain")));

            container.Register(Component.For<IDataAccessManager>().ImplementedBy<DataAccessManager>().LifestyleScoped());
            container.Register(Component.For<PaymentGenerationDbContext>().ImplementedBy<PaymentGenerationDbContext>().LifestyleScoped());
            container.Register(Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped());
            container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped());
            container.Register(Component.For<ISubnominalAggregationRepository>()
                .ImplementedBy<SubnominalAggregationRepository>()
                .LifestyleScoped());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }
    }
}
