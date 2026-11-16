namespace CrossDomain.Integration.Common.Tests.Unit.Reporting
{
    using System.Net;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    //using SFA.FCT.CrossDomain.Integration.Common.ReportExecution2005;
    //using SFA.FCT.CrossDomain.Integration.Common.Reporting;

    [TestClass]
    public class ReportingServicesClientTests
    {
        //#region Additional test attributes
        ////
        //// You can use the following additional attributes as you write your tests:
        ////
        //// Use ClassInitialize to run code before running the first test in the class
        //// [ClassInitialize()]
        //// public static void MyClassInitialize(TestContext testContext) { }
        ////
        //// Use ClassCleanup to run code after all tests in a class have run
        //// [ClassCleanup()]
        //// public static void MyClassCleanup() { }
        ////
        //// Use TestInitialize to run code before running each test 
        //// [TestInitialize()]
        //// public void MyTestInitialize() { }
        ////
        //// Use TestCleanup to run code after each test has run
        //// [TestCleanup()]
        //// public void MyTestCleanup() { }
        ////
        //#endregion

        //[TestMethod,TestCategory("UnitTest")]
        //public void RenderReportWs_ShouldSetTheReportCredentials()
        //{
        //    var serviceMock = new Mock<IReportExecutionService>();
        //    serviceMock.SetupProperty(x => x.ExecutionHeaderValue);

        //    var client = new ReportingServicesClient()
        //    {
        //        ReportService = serviceMock.Object
        //    };
        //    var result = client.RenderReportWs("A", "B", new[] {new[] {"C", "D"}, new[] {"E", "F"}}, "A");
        //    serviceMock.VerifySet(x => x.Credentials = It.IsAny<NetworkCredential>(), Times.Once(), "RenderReportWs didn't set the credentials");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void RenderReportWs_ShouldSetTimeout()
        //{
        //    var serviceMock = new Mock<IReportExecutionService>();
        //    serviceMock.SetupProperty(x => x.ExecutionHeaderValue);

        //    var client = new ReportingServicesClient()
        //    {
        //        ReportService = serviceMock.Object
        //    };
        //    var result = client.RenderReportWs("A", "B", new[] { new[] { "C", "D" }, new[] { "E", "F" } }, "A");
        //    serviceMock.VerifySet(x => x.Timeout = 600000, Times.Once(), "RenderReportWs didn't set the timeout from config");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void RenderReportWs_ShouldLoadTheReport()
        //{
        //    var serviceMock = new Mock<IReportExecutionService>();
        //    serviceMock.SetupProperty(x => x.ExecutionHeaderValue);

        //    var client = new ReportingServicesClient()
        //    {
        //        ReportService = serviceMock.Object
        //    };
        //    var result = client.RenderReportWs("A", "B", new[] { new[] { "C", "D" }, new[] { "E", "F" } }, "A");
        //    serviceMock.Verify(x => x.LoadReport("AA",null), Times.Once(), "RenderReportWs didn't load the report");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void RenderReportWs_ShouldSetTheParameters()
        //{
        //    var serviceMock = new Mock<IReportExecutionService>();
        //    serviceMock.SetupProperty(x => x.ExecutionHeaderValue);

        //    var client = new ReportingServicesClient()
        //    {
        //        ReportService = serviceMock.Object
        //    };
        //    var result = client.RenderReportWs("A", "B", new[] { new[] { "C", "D" }, new[] { "E", "F" } }, "A");
        //    serviceMock.Verify(x => x.SetExecutionParameters(
        //        It.Is<ParameterValue[]>(y => y[0].Name == "C" && y[1].Name == "E"), "en-GB"), Times.Once(), "RenderReportWs didn't set the parameters");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void RenderReportWs_ShouldRenderThereport()
        //{
        //    var serviceMock = new Mock<IReportExecutionService>();
        //    serviceMock.SetupProperty(x => x.ExecutionHeaderValue);

        //    var client = new ReportingServicesClient()
        //    {
        //        ReportService = serviceMock.Object
        //    };
        //    var result = client.RenderReportWs("A", "B", new[] { new[] { "C", "D" }, new[] { "E", "F" } }, "A");

        //    string extension;
        //    string mimetype;
        //    string encoding;
        //    Warning[] warnings;
        //    string[] streamIds;
            
        //    serviceMock.Verify(x => x.Render("B", It.IsAny<string>(), 
        //        out extension, 
        //        out mimetype, 
        //        out encoding, 
        //        out warnings, 
        //        out streamIds),
        //        Times.Once(), "RenderReportWs didn't render the report");
        //}
    }
}
