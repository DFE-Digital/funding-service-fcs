namespace CrossDomain.Integration.ReportRunnerEndpoint.Tests.Unit
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using ContractManagement.DataStore.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class RunReportCommandCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RunReportCommandCreator_GetRunReportCommands_ShouldReturnBothLatestVersionAndLastApprovedCommands()
        {
            // arrange
            ReportConfig reportConfig = new ReportConfig("16-19 Funding", new List<string> { "1619LR1718", "NMF1718", "SSF1718" });

            // act
            IReadOnlyCollection<RunReportCommand> commands = RunReportCommandCreator.GetRunReportCommands(reportConfig);

            // assert
            Assert.AreEqual(2, commands.Count, "Incorrect number of commands returned");

            Assert.IsTrue(commands.All(c => c.ReportName == ConfigurationManager.AppSettings["ReportDelivery.ReportName"]), "ReportName not correctly set in commands");

            Assert.IsTrue(commands.All(c => c.ReportParameters[0][0] == "FundingStreamPeriod"), "FundingStreamPeriod parameter not set in commands");
            Assert.IsTrue(commands.All(c => c.ReportParameters[0][1] == reportConfig.ToString()), "CSV of FSPs parameter not set in commands");

            Assert.AreEqual(1, commands.Count(c => c.ReportParameters[1][0] == "IsLatestVersion" && c.ReportParameters[1][1] == "True"), "Latest Version command not returned");
            Assert.AreEqual(1, commands.Count(c => c.ReportParameters[1][0] == "IsLatestVersion" && c.ReportParameters[1][1] == "False"), "Last Approved Version command not returned");

            Assert.IsTrue(commands.All(c => c.ReportFormat == "CSV"), "ReportFormat not correctly set in commands");
            Assert.IsTrue(commands.All(c => c.ReportPath == @"/"), "ReportPath not correctly set in commands");

            Assert.IsTrue(commands.All(c => c.FileName.StartsWith("CDA") && c.FileName.EndsWith(".csv") && c.FileName.Contains(reportConfig.Description) &&
                (
                    (c.ReportParameters[1][1] == "True" && c.FileName.Contains(" Latest Version ")) ||
                    (c.ReportParameters[1][1] == "False" && c.FileName.Contains(" Last Approved Version "))
                )));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RunReportCommandCreator_GetLastApprovedVersionRunReportCommands_ShouldReturnLastApprovedVersionCommandsOnly()
        {
            // arrange
            ReportConfig reportConfig = new ReportConfig("16-19 Funding", new List<string> { "1619LR1718", "NMF1718", "SSF1718" });

            // act
            IReadOnlyCollection<RunReportCommand> commands = RunReportCommandCreator.GetLastApprovedVersionRunReportCommands(reportConfig);

            // assert
            Assert.AreEqual(1, commands.Count, "Incorrect number of commands returned");
            Assert.AreEqual(0, commands.Count(c => c.ReportParameters[1][0] == "IsLatestVersion" && c.ReportParameters[1][1] == "True"), "Unexpected Latest Version command returned");
            Assert.AreEqual(1, commands.Count(c => c.ReportParameters[1][0] == "IsLatestVersion" && c.ReportParameters[1][1] == "False"), "Last Approved Version command not returned");
        }
    }
}
