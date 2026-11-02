namespace PaymentManagementDomain.AllocationActualsVerified
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using PaymentManagementDomain.AllocationActualsVerified.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;

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
                Component.For<IAllocationActualsRepository>().ImplementedBy<AllocationActualsRepository>()
                    .LifestyleScoped(),
                Component.For<IPayCalcPolicyQueryRepository>().ImplementedBy<PayCalcPolicyQueryRepository>()
                    .LifestyleScoped(),
                Component.For(typeof(IEntityCache<,>)).ImplementedBy(typeof(EntityCache<,>)).LifestyleSingleton(),
                Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton()
                );
        }
    }
}
