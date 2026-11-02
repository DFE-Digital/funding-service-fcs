namespace FCT.Operations.Integrity.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.Handlers;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCT.Operations.Integrity.IoC;
    using Castle.MicroKernel.Lifestyle;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class OperationalCheckShortIntervalHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OperationalCheckShortIntervalHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<OperationalCheckShortIntervalCommand>>()
                .ImplementedBy<OperationalCheckShortIntervalHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<OperationalCheckShortIntervalCommand>>();
            }
        }
    }
}
