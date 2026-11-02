namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Repositories;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Services;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Xrm.Infrastructure;

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
                Component.For<IOrganizationService>().UsingFactoryMethod(k => CrmConnectionFactory.GetOrganizationService()).LifestyleScoped(),
                Component.For<IContractDeliverablePeriodRepository>().ImplementedBy<ContractDeliverablePeriodRepository>().LifestyleScoped(),
                Component.For<IContractDeliverablePeriodPresenceChecker>().ImplementedBy<ContractDeliverablePeriodPresenceChecker>().LifestyleSingleton(),
                Component.For<ISubnominalAggregationRepository>().ImplementedBy<SubnominalAggregationRepository>().LifestyleScoped(),
                Component.For<IFundingStreamPeriodRepository>().ImplementedBy<FundingStreamPeriodRepository>().LifestyleScoped(),
                Component.For<IOrganisationRepository>().ImplementedBy<OrganisationRepository>().LifestyleScoped(),
                Component.For<IPaymentAggregationXrmManager>().ImplementedBy<PaymentAggregationXrmManager>().LifestyleScoped(),
                Component.For<IProcessedMessageRepository>().ImplementedBy<ProcessedMessageRepository>().LifestyleSingleton(),
                Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton()
            );
        }
    }
}
