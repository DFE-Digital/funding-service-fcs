namespace PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint
{
    using BusinessLogic;
    using BusinessLogic.Mappers;
    using BusinessLogic.Services;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Integration.DataStore;
    using Integration.DataStore.Repositories;
    using Services;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
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
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentGenerationDomain")),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<IPaymentRunService>().ImplementedBy<PaymentRunService>().LifestyleScoped(),
                Component.For<IPaymentCorpSchemaMapper>().ImplementedBy<PaymentCorpSchemaMapper>().LifestyleSingleton(),
                Component.For<IPaymentGenerationXmlValidator>().ImplementedBy<PaymentGenerationXmlValidator>().LifestyleTransient(),
                Component.For<IDataAccessManager>().ImplementedBy<DataAccessManager>().LifestyleScoped(),
                Component.For<ISubnominalAggregationRepository>().ImplementedBy<SubnominalAggregationRepository>().LifestyleScoped(),
                Component.For<PaymentGenerationDbContext>().ImplementedBy<PaymentGenerationDbContext>().LifestyleScoped(),
                Component.For<IMonitoringDeliverableStore>().ImplementedBy<MonitoringDeliverableStore>().LifestyleScoped(),
                Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleScoped(),
                Component.For<IPaymentBatchFeedItemCommandRepository>().ImplementedBy<PaymentBatchFeedItemRepository>().LifestyleScoped(),
                Component.For<IFcsConfiguration>().ImplementedBy<FrameworkConfiguration>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodQueryRepository>().ImplementedBy<FundingStreamPeriodQueryRepository>().LifestyleScoped());
        }
    }
}