namespace FCT.Operations.Maintenance.Endpoint.Tests.Handlers
{
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Operations.Maintenance.Endpoint.Handlers;
    using SFA.FCT.Operations.Maintenance.Endpoint.IoC;
    using Castle.MicroKernel.Lifestyle;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class MaintainAuditQueueHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MaintainAuditQueueHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<MaintainAuditQueueCommand>>()
                .ImplementedBy<MaintainAuditQueueHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<MaintainAuditQueueCommand>>();
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void MaintainAuditQueueHandler_ShouldRecursivelyClearQueueToDesiredSizeViaMessages()
        {
            MaintainAuditQueueCommand generatedCommand;

            // arrange
            var context = new TestableMessageHandlerContext();

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()))
                .Register(Component.For<MaintainAuditQueueHandler>().LifestyleTransient());

            MaintainAuditQueueHandler handler = container.Resolve<MaintainAuditQueueHandler>();

            // act
            do
            {
                generatedCommand = null;
                handler.Handle(new MaintainAuditQueueCommand(), context);
            } while (generatedCommand != null);
        }
    }
}
