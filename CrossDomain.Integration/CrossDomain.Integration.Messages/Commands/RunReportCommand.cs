namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class RunReportCommand
    {
        public string ReportName { get; set; }

        public string[][] ReportParameters { get; set; }

        public string ReportFormat { get; set; }

        public string FileName { get; set; }

        public string ReportPath { get; set; }

        public string ArchiveChildFolderName { get; set; }
    }
}
