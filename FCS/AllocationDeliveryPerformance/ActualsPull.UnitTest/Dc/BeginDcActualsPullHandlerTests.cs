namespace ActualsPull.Tests.Dc
{
    using ActualsPull.Dc;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class BeginDcActualsPullHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BeginDcActualsPullHandler_ShouldResolve()
        {
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(l => l.CreateDefaultLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(loggerFactoryMock.Object))
                .Register(Component.For<BeginDcActualsPullHandler>().ImplementedBy<BeginDcActualsPullHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<BeginDcActualsPullHandler>();
        }
    }
}
