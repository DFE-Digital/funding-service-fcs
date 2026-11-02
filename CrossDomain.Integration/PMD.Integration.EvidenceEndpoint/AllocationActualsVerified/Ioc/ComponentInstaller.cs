namespace SFA.FCT.PMD.Integration.EvidenceEndpoint.AllocationActualsVerified.Ioc
{
    using System.Diagnostics.CodeAnalysis;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.Integration.RulesEngine;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PMD.PaymentManagment.DataStore;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;

    [ExcludeFromCodeCoverage]
    public class ComponentInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public ComponentInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<IRulesEngine>().ImplementedBy<RulesEngine>().LifestyleSingleton(),
                Component.For<IDate>().ImplementedBy<Date>().LifestyleSingleton(),
                Component.For<IPaymentManager>().ImplementedBy<PaymentManager>().LifeStyle.Transient,
                Component.For<IPaymentManagementPolicyContext>()
                    .ImplementedBy<PaymentManagementPolicyContext>()
                    .LifeStyle.Transient,
                Component.For<IPaymentSchedulePolicyContext>()
                    .ImplementedBy<PaymentSchedulePolicyContext>()
                    .LifeStyle.Transient,
                Component.For<IPaymentManagementDBContext>()
                    .ImplementedBy<PaymentManagementDBContext>()
                    .LifeStyle.Transient,
                Component.For<IOverrideDateDBContext>()
                    .ImplementedBy<OverrideDateDBContext>()
                    .LifeStyle.Transient,
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentManagementDomain")));
        }
    }
}
