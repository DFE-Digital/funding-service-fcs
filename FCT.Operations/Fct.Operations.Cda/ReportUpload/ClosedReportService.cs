namespace FCT.Operations.Cda.ReportUpload
{
    using Infrastructure;
    using SFA.FCS.Worker.Common;
    using Dtos;
    using Infrastructure.Csv;
    using System.Linq;

    public class ClosedReportService : IClosedReportService
    {
        private readonly IOffice365StorageWrapper _office365Adapter;
        private readonly IFcsConfiguration _configuration;
        private const string ArchiveFolderName = "Archive";
        private string O365Folder => _configuration["ReportDelivery.CdaO365Folder"];

        public ClosedReportService(IOffice365StorageWrapper office365Adapter, IFcsConfiguration configuration)
        {
            _office365Adapter = office365Adapter;
            _configuration = configuration;
        }

        public void UploadReportToSharePointIfNecessary(Report report)
        {
            var folderName = $"_{report.ArchivedYear} Closed";

            CreateArchiveRootFolderAndChildFolder(folderName);

            if (ReportDoesNotExist(folderName, report.ReportName))
            {
                UploadFile(report, folderName);
            }
        }

        private void CreateArchiveRootFolderAndChildFolder(string archiveChildFolderName)
        {
            CreateArchiveRootFolderIfNecessary();

            _office365Adapter.CreateFolder(rootListName: O365Folder, listName: ArchiveFolderName, folderName: archiveChildFolderName);
        }

        private void CreateArchiveRootFolderIfNecessary()
        {
            if (!_office365Adapter.DoesFolderExist(listName: O365Folder, folderName: ArchiveFolderName))
            {
                _office365Adapter.CreateFolder(listName: O365Folder, folderName: ArchiveFolderName);
            }
        }

        private bool ReportDoesNotExist(string folderName, string reportName)
        {
            return !_office365Adapter.DoesFileExist(O365Folder, $"{ArchiveFolderName}/{folderName}/{reportName}");
        }

        private void UploadFile(Report report, string folderName)
        {
            // first convert the report to CSV string,
            var csvRows = new CsvCreator<CdaRow>().CreateFileLines(report.Rows);

            // then bytes
            var bytes = csvRows.SelectMany(r => System.Text.Encoding.UTF8.GetBytes(r + System.Environment.NewLine)).ToArray();

            //add report
            _office365Adapter.UploadFileToFolderWithOverwrite(
                fileName: report.ReportName,
                content: bytes,
                rootFolder: O365Folder,
                childFolder: ArchiveFolderName,
                childOfChildFolder: folderName);
        }
    }
}