using System;
using System.Text;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

namespace CrossDomain.Integration.Common.Tests.Unit.Reporting
{
    using Moq;
    using ReportRunnerEndpoint;
    using SFA.FCT.CrossDomain.Integration.Common.Reporting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Common;

    /// <summary>
    /// Summary description for ReportRunnerTests
    /// </summary>
    [TestClass]
    public class ReportRunnerTests
    {
        public ReportRunnerTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        #region RunReport Tests
        
        [TestMethod,TestCategory("UnitTest")]
        public void RunReport_ShouldRenderTheReport()
        {
            var message = new RunReportCommand()
            {
                FileName="A",
                ReportFormat="B",
                ReportName="c",
                ReportParameters = new[] { new[] {"e","f"}, new[] {"g","h"}},
                ReportPath = "D"
            };
            var clientMock = new Mock<IReportingServicesClient>();
            var loggerMock = new Mock<ILogger>();
            var adapterMock = new Mock<IOffice365Adapter>();
            var runner = new ReportRunner()
            {
                Client = clientMock.Object,
                Office365Adapter = adapterMock.Object,
                Logger = loggerMock.Object
            };
            runner.RunReport(message);
            clientMock.Verify(y => y.RenderReportWs("c", "B", It.Is<string[][]>(x=>x[0][0]=="e" && x[1][0]=="g"), "D"),Times.Once(),
                "RunReport didn't render the report");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RunReport_ShouldUploadTheReportOutputToOffice365()
        {
            var message = new RunReportCommand()
            {
                FileName = "A",
                ReportFormat = "B",
                ReportName = "c",
                ReportParameters = new[] { new[] { "e", "f" }, new[] { "g", "h" } },
                ReportPath = "D"
            };
            var report = new Byte[0];
            var clientMock = new Mock<IReportingServicesClient>();
            clientMock.Setup(y => y.RenderReportWs("c", "B", It.Is<string[][]>(x => x[0][0] == "e" && x[1][0] == "g"), "D")).Returns(report);
            var loggerMock = new Mock<ILogger>();
            var adapterMock = new Mock<IOffice365Adapter>();
            var runner = new ReportRunner()
            {
                Client = clientMock.Object,
                Office365Adapter = adapterMock.Object,
                Logger = loggerMock.Object
            };
            runner.RunReport(message);
            adapterMock.Verify(y => y.UploadFileWithOverwrite("A", report,It.IsAny<string>()), Times.Once(),
                "RunReport didn't output the report to office365");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void RunReport_ShouldLogAnError_WhenAnExceptionIsThrown()
        {
            var message = new RunReportCommand()
            {
                FileName = "A",
                ReportFormat = "B",
                ReportName = "c",
                ReportParameters = new[] { new[] { "e", "f" }, new[] { "g", "h" } },
                ReportPath = "D"
            };
            var testException = new Exception("Test Exception");
            var clientMock = new Mock<IReportingServicesClient>();
            clientMock.Setup(y => y.RenderReportWs("c", "B", It.Is<string[][]>(x => x[0][0] == "e" && x[1][0] == "g"), "D")).Throws(testException);
            var loggerMock = new Mock<ILogger>();
            var adapterMock = new Mock<IOffice365Adapter>();
            var runner = new ReportRunner()
            {
                Client = clientMock.Object,
                Office365Adapter = adapterMock.Object,
                Logger = loggerMock.Object
            };
            runner.RunReport(message);
            loggerMock.Verify(y => y.LogError(CommonLoggingEventId.RenderReportFailed, testException.Message,It.IsAny<string>(),"A"), Times.Once(),
                "RunReport didn't Log the error when an exception occurred");
        }
        #endregion

        
    }
}
