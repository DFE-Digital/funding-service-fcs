namespace OrganisationDomain.Integration.InitOrganisationUpdate.Console.Tests
{
    using System;
    using InitiateOrganisationUpdate;
    using Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Logging;

    [TestClass]
    public class InitiateTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Update_ShouldSend_InitOrganisationUpdateCommand()
        {
            // Arrange
            var busMock = new Mock<IBus>();
            var loggerMock = new Mock<ILog>();

            var init = new Initiate
            {
                Bus = busMock.Object,
                Logger = loggerMock.Object
            };

            // Act
            init.Update();

            // Assert
            busMock.Verify(x => x.Send(It.Is<InitOrganisationUpdate>(y => 
                y.ProcessId.Equals("UpdateOrgServiceSaga"))));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Update_ShouldLogInfo_Complete()
        {
            // Arrange
            var busMock = new Mock<IBus>();
            var loggerMock = new Mock<ILog>();

            var init = new Initiate
            {
                Bus = busMock.Object,
                Logger = loggerMock.Object
            };

            // Act
            init.Update();

            // Assert
            loggerMock.Verify(x => x.Info(It.Is<string>(y => y.Contains("complete"))));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Update_OnError_ShouldLogError()
        {
            // Arrange
            var e = new Exception();
            
            var busMock = new Mock<IBus>();
            busMock.Setup(x => x.Send(It.IsAny<InitOrganisationUpdate>())).Throws(e);
            var loggerMock = new Mock<ILog>();

            var init = new Initiate
            {
                Bus = busMock.Object,
                Logger = loggerMock.Object
            };

            // Act
            init.Update();

            // Assert
            loggerMock.Verify(x => x.Error(It.Is<String>(y => y.Contains("failed")), e));
        }
    }
}
