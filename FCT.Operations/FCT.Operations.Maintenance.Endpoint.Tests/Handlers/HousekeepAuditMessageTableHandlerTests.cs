namespace FCT.Operations.Maintenance.Endpoint.Tests.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Operations.Maintenance.Endpoint.Handlers;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Maintenance.Endpoint.IoC;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class HousekeepAuditMessageTableHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void HousekeepAuditMessageTableHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<HousekeepAuditMessageTable>>()
                .ImplementedBy<HousekeepAuditMessageTableHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<HousekeepAuditMessageTable>>();
            }
        }
    }
}