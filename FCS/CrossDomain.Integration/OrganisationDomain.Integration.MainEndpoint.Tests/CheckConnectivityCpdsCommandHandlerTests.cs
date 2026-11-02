namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CheckConnectivityCpdsCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckConnectivityCpdsCommandHandler_ShouldResolve()
        {
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(l => l.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            var container = OrganisationDomain.Integration.MainEndpoint.Ioc.Bootstrapper
                .CreateContainer(loggerFactoryMock.Object)
                .Register(Component.For<CheckConnectivityCpdsCommandHandler>().LifestyleScoped());
            container.BeginScope();

            var handler = container.Resolve<CheckConnectivityCpdsCommandHandler>();

            Assert.IsNotNull(handler, "Could not resolve");
        }
    }
}
