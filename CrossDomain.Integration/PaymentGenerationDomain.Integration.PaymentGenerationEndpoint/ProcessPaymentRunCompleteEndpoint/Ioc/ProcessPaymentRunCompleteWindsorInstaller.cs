namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint.Ioc
{
    using System.Diagnostics.CodeAnalysis;
    using BusinessLogic.Mappers;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;
    using BusinessLogic;
    using DataStore;
    using DataStore.Repositories;
    using Infrastructure;
    using Microsoft.Extensions.Logging;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;

    [ExcludeFromCodeCoverage]
    public class ProcessPaymentRunCompleteWindsorInstaller : IWindsorInstaller
    {
        private readonly ILoggerFactory _loggerFactory;

        public ProcessPaymentRunCompleteWindsorInstaller(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<ILogger>().Instance(_loggerFactory.CreateLogger("PaymentGenerationDomain")));
            container.Register(Component.For<IDataAccessManager>().ImplementedBy<DataAccessManager>().LifestyleScoped());
            container.Register(Component.For<IAggregatedPaymentMapper>().ImplementedBy<AggregatedPaymentMapper>().LifestyleScoped());
            container.Register(Component.For<PaymentGenerationDbContext>().ImplementedBy<PaymentGenerationDbContext>().LifestyleScoped());
            container.Register(Component.For<IPaymentSchedulePolicyContext>().ImplementedBy<PaymentSchedulePolicyContext>().LifestyleScoped());
            container.Register(Component.For<ISubnominalAggregationRepository>().ImplementedBy<SubnominalAggregationRepository>().LifestyleScoped());
            container.Register(Component.For<IPaymentTimetableRepository>().ImplementedBy<PaymentTimetableRepository>().LifestyleScoped());
            container.Register(Component.For<IOutstandingPaymentsChecker>().ImplementedBy<OutstandingPaymentsChecker>().LifestyleScoped());
            container.Register(Component.For<IDate>().ImplementedBy<StaticDate>().LifestyleScoped());
            container.Register(Component.For<IOverrideDateDBContext>().ImplementedBy<OverrideDateDBContext>().LifestyleScoped());
            container.Register(Component.For<ISessionConnectionFactory>().ImplementedBy<SessionConnectionFactory>().LifestyleSingleton());
        }
    }
}
