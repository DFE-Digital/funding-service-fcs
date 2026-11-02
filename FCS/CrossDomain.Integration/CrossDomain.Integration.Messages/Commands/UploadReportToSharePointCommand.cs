namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class UploadReportToSharePointCommand
    {
        public string ReportName { get; set; }

        public string ArchiveFolderName { get; set; }

        public bool ShouldArchive => !string.IsNullOrEmpty(ArchiveFolderName);
        
        public override string ToString()
        {
            return $"ReportName: {ReportName}";
        }
    }
}
