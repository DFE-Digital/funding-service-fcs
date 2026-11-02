namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint.Ioc;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Moq;

    public abstract class MDEnrichEndpointIntegrationTestBase
    {
        protected MDEnrichEndpointIntegrationTestBase()
        {
            SetupIoC();
        }

        protected IWindsorContainer Container { get; private set; }

        protected IWindsorContainer PaymentScheduleContainer { get; private set; }

        private void SetupIoC()
        {
            Container = new WindsorContainer().Install(new ComponentInstaller(new LoggerFactory()));
            Container.Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
            Container.BeginScope();
            PaymentScheduleContainer = new WindsorContainer()
                .Install(new SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory()));
        }
    }
}
