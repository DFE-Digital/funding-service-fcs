namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.IoC
{
    using BusinessLogic.Repositories;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Framework.Logging.Interfaces;
    using Repositories;
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
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentManagementDomain")),
                Component.For<ILevyMissingDeliverablePeriodCreator>().ImplementedBy<LevyMissingDeliverablePeriodCreator>().LifestyleScoped(),
                Component.For<ICrmDeliverablePeriodRepository>().ImplementedBy<CrmDeliverablePeriodRepository>().LifestyleScoped(),
                Component.For<IContractDeliverablePeriodPresenceChecker>().ImplementedBy<ContractDeliverablePeriodPresenceChecker>().LifestyleSingleton(),
                Component.For<IContractDeliverablePeriodRepository>().ImplementedBy<ContractDeliverablePeriodRepository>().LifestyleScoped(),
                Component.For<ICrmAllocationRepository>().ImplementedBy<CrmAllocationRepository>().LifestyleScoped());
        }
    }
}
