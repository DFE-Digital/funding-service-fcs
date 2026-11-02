namespace CrossDomain.Integration.ReportRunnerEndpoint.Services
{
    using System.Collections.Generic;
    using System.Configuration;
    using ContractManagement.DataStore.Dtos;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public static class RunReportCommandCreator
    {
        private const string ReportParameterFundingStreamPeriod = "FundingStreamPeriod";
        private const string ReportParameterLatestVersion = "IsLatestVersion";
        private const string ReportFormat = "CSV";
        private const string FileExtension = ".csv";
        private const string ReportPath = @"/";

        public static IReadOnlyCollection<RunReportCommand> GetRunReportCommands(ReportConfig reportConfig)
        {
            List<RunReportCommand> commands = new List<RunReportCommand>();

            commands.AddRange(GetLatestVersionRunReportCommands(reportConfig));
            commands.AddRange(GetLastApprovedVersionRunReportCommands(reportConfig));

            return commands;
        }

        public static IReadOnlyCollection<RunReportCommand> GetLastApprovedVersionRunReportCommands(ReportConfig reportConfig)
        {
            string reportName = ConfigurationManager.AppSettings["ReportDelivery.ReportName"];

            var reportParams = new[]
            {
                new[] { ReportParameterFundingStreamPeriod, reportConfig.ToString() },
                new[] { ReportParameterLatestVersion, false.ToString() }
            };

            var command = new RunReportCommand
            {
                ReportName = reportName,
                ReportParameters = reportParams,
                ReportFormat = ReportFormat,
                ReportPath = ReportPath,
                FileName = GetFileName(isLatestVersion: false, reportDescription: reportConfig.Description)
            };

            return new List<RunReportCommand> { command };
        }

        private static IReadOnlyCollection<RunReportCommand> GetLatestVersionRunReportCommands(ReportConfig reportConfig)
        {
            string reportName = ConfigurationManager.AppSettings["ReportDelivery.ReportName"];

            var reportParams = new[]
            {
                new[] { ReportParameterFundingStreamPeriod, reportConfig.ToString() },
                new[] { ReportParameterLatestVersion, true.ToString() }
            };

            var command = new RunReportCommand
            {
                ReportName = reportName,
                ReportParameters = reportParams,
                ReportFormat = ReportFormat,
                ReportPath = ReportPath,
                FileName = GetFileName(isLatestVersion: true, reportDescription: reportConfig.Description)
            };

            return new List<RunReportCommand> { command };
        }

        private static string GetFileName(bool isLatestVersion, string reportDescription)
        {
            return string.Concat(
                "CDA",
                isLatestVersion ? " Latest Version " : " Last Approved Version ",
                reportDescription, FileExtension);
        }
    }
}
