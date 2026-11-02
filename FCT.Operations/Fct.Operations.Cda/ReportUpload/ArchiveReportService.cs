namespace FCT.Operations.Cda.ReportUpload
{
    using Infrastructure;
    using SFA.FCS.Worker.Common;

    public class ArchiveReportService : IArchiveReportService
    {
        private readonly IOffice365StorageWrapper _office365Adapter;
        private readonly IFcsConfiguration _configuration;
        private string O365Folder => _configuration["ReportDelivery.CdaO365Folder"];
        private const string ArchiveFolderName = "Archive";

        public ArchiveReportService(IOffice365StorageWrapper office365Adapter, IFcsConfiguration configuration)
        {
            _office365Adapter = office365Adapter;
            _configuration = configuration;
        }

        public void WriteFileToArchiveFolder(string fileName, string archiveChildFolderName)
        {
            var fileContents = _office365Adapter.GetFileContents(fileName, O365Folder);

            _office365Adapter.UploadFileToFolderWithOverwrite(
                fileName: fileName,
                content: fileContents,
                rootFolder: O365Folder,
                childFolder: ArchiveFolderName,
                childOfChildFolder: archiveChildFolderName);
        }
    }
}
