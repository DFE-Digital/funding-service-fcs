namespace WorkerRole.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.Framework.Logging.Bespoke;

    [TestClass]
    public class BootstrapperTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void Bootstrapper_ShouldStartEndpoint()
        {
            try
            {
                // act
                Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
                loggerFactoryMock.Setup(lf => lf.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());
                Bootstrapper.Start(loggerFactoryMock.Object, Mock.Of<ILogger>()).Wait();

                IReadOnlyCollection<IEndpointInstance> instances = Bootstrapper.Endpoints;

                // assert
                Assert.IsTrue(instances.Any());
            }
            finally
            {
                Bootstrapper.Stop().Wait();
            }
        }
    }
}
