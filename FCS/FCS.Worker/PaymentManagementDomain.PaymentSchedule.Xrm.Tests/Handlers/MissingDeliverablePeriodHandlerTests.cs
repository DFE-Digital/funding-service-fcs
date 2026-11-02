namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.MissingDeliverablePeriod;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class MissingDeliverablePeriodHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MissingDeliverablePeriodHandler_ShouldResolve()
        {
            var handler = GetContainer().Resolve<IHandleMessages<AddMissingDeliverablePeriodCommand>>();

            Assert.IsNotNull(handler);
        }

        private IWindsorContainer GetContainer()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IHandleMessages<AddMissingDeliverablePeriodCommand>>().ImplementedBy<MissingDeliverablePeriodHandler>());

            container.BeginScope();

            return container;
        }
    }
}
