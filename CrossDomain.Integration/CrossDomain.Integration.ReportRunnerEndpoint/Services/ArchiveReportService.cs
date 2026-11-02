namespace CrossDomain.Integration.ReportRunnerEndpoint.Services
{
    using System;
    using System.Configuration;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class ArchiveReportService : IArchiveReportService
    {
        private readonly IOffice365Adapter _office365Adapter;
        private const string ArchiveFolderName = "Archive";
        private static string O365Folder => ConfigurationManager.AppSettings["ReportDelivery.CdaO365Folder"];

        public ArchiveReportService(IOffice365Adapter office365Adapter)
        {
            _office365Adapter = office365Adapter;
        }

        public void CreateArchiveRootFolderAndChildFolder(string archiveChildFolderName)
        {
            CreateArchiveRootFolderIfNecessary();

            _office365Adapter.CreateFolder(rootListName: O365Folder, listName: ArchiveFolderName, folderName: archiveChildFolderName);
        }

        public void WriteFileToArchiveFolder(string fileName, string archiveChildFolderName)
        {
            var fileContents = _office365Adapter.GetFileContents(fileName, O365Folder);

            _office365Adapter.UploadFileToFolderWithOverwrite(fileName: fileName, content: fileContents, rootFolder: O365Folder, childFolder: ArchiveFolderName, childOfChildFolder: archiveChildFolderName);
        }

        public string GenerateArchiveChildFolderName()
        {
            return DateTime.UtcNow.ToString("yyyy_MM_dd_'T'_HH_mm");
        }

        private void CreateArchiveRootFolderIfNecessary()
        {
            if (!_office365Adapter.DoesFolderExist(listName: O365Folder, folderName: ArchiveFolderName))
            {
                _office365Adapter.CreateFolder(listName: O365Folder, folderName: ArchiveFolderName);
            }
        }      
    }
}
