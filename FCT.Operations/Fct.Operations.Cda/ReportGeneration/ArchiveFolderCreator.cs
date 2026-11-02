namespace FCT.Operations.Cda.ReportGeneration
{
    using System;
    using Infrastructure;
    using SFA.FCS.Worker.Common;

    public class ArchiveFolderCreator : IArchiveFolderCreator
    {
        private readonly IOffice365StorageWrapper _office365Adapter;
        private readonly IFcsConfiguration _configuration;
        private const string ArchiveFolderName = "Archive";
        private string O365Folder => _configuration["ReportDelivery.CdaO365Folder"];

        public ArchiveFolderCreator(IOffice365StorageWrapper office365Adapter, IFcsConfiguration configuration)
        {
            _office365Adapter = office365Adapter;
            _configuration = configuration;
        }

        public void CreateArchiveRootFolderAndChildFolder(string archiveChildFolderName)
        {
            CreateArchiveRootFolderIfNecessary();

            _office365Adapter.CreateFolder(rootListName: O365Folder, listName: ArchiveFolderName, folderName: archiveChildFolderName);
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
