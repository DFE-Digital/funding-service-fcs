namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.IoC
{
    using System;
    using System.Configuration;
    using AllocationDeliveryDomain.Common.DataStore;
    using BusinessLogic.Services;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using PolicyCache.DataStore;
    using PolicyCache.DataStore.Repositories;
    using Services;

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
                Component.For<IPaymentAggregationService>().ImplementedBy<PaymentAggregationService>().LifestyleScoped(),
                Component.For<IDeliverableToSubnominalService>().ImplementedBy<DeliverableToSubnominalService>().LifestyleScoped(),
                Component.For<IPayCalcPolicyQueryRepository>().ImplementedBy<PayCalcPolicyQueryRepository>().LifestyleScoped(),
                Component.For(typeof(IEntityCache<,>)).ImplementedBy(typeof(EntityCache<,>)).LifestyleSingleton(),
                Component.For<IMonitoringDeliverablesDbContext>().ImplementedBy<MonitoringDeliverablesDbContext>().LifestyleScoped(),
                Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped(),
                Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton(),
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentManagementDomain")),
                ParseDateRegistration());
        }

        private static IRegistration ParseDateRegistration()
        {
            var useRealDate = Convert.ToBoolean(ConfigurationManager.AppSettings["UseRealDate"]);

            return useRealDate ? Component.For<IDate>().ImplementedBy<SystemDate>().LifestyleSingleton() : Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleSingleton();
        }
    }
}
