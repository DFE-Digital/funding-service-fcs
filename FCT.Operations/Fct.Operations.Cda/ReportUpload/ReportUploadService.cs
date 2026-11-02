namespace FCT.Operations.Cda.ReportUpload
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Infrastructure;
    using Infrastructure.Csv;
    using SFA.FCS.Worker.Common;

    public class ReportUploadService : IReportUploadService
    {
        private readonly IOffice365StorageWrapper _office365Adapter;
        private readonly IFcsConfiguration _configuration;

        private string Office365Folder => _configuration["ReportDelivery.CdaO365Folder"];
        private const string ArchiveFolderName = "Archive";

        public ReportUploadService(IOffice365StorageWrapper office365Adapter, IFcsConfiguration configuration)
        {
            _office365Adapter = office365Adapter;
            _configuration = configuration;
        }

        public void UploadReportToSharePoint(Report report)
        {
            // first convert the report to CSV string,
            List<string> csvRows = new CsvCreator<CdaRow>().CreateFileLines(report.Rows);

            // then bytes
            
            var bytes = csvRows.SelectMany(r => System.Text.Encoding.UTF8.GetBytes(r + System.Environment.NewLine) ).ToArray();

            // then upload
            _office365Adapter.UploadFileWithOverwrite(fileName: report.ReportName, content: bytes, targetListName: Office365Folder);
        }

        public void WriteFileToArchiveFolder(string fileName, string archiveChildFolderName)
        {
            if (_office365Adapter.DoesFileExist(Office365Folder, fileName))
            {
                var fileContents = _office365Adapter.GetFileContents(fileName, Office365Folder);

                _office365Adapter.UploadFileToFolderWithOverwrite(
                    fileName: fileName,
                    content: fileContents,
                    rootFolder: Office365Folder,
                    childFolder: ArchiveFolderName,
                    childOfChildFolder: archiveChildFolderName);
            }
        }
    }
}
