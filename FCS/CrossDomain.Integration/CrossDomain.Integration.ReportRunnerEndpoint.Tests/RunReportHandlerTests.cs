namespace CrossDomain.Integration.ReportRunnerEndpoint.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.Reporting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class RunReportHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReportRunner_ShouldRetryWhenExceptionIsThrown()
        {
            // arrange
            ReportRunner reportRunner = new ReportRunner();
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            reportRunner.Logger = loggerMock.Object;
            Mock<IOffice365Adapter> office365Mock = new Mock<IOffice365Adapter>();
            reportRunner.Office365Adapter = office365Mock.Object;
            Mock<IReportingServicesClient> reportingClient = new Mock<IReportingServicesClient>();
            reportingClient.SetupSequence(
                r =>
                    r.RenderReportWs(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string[][]>(), It.IsAny<string>()))
                .Throws(new Exception())
                .Returns(new byte[0]);

            reportRunner.Client = reportingClient.Object;

            // act
            reportRunner.RunReport(new RunReportCommand());

            // assert
            loggerMock.Verify(l => l.LogError(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<object[]>()), Times.Never);
        }
    }
}
