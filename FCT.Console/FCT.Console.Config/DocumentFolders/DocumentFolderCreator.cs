namespace FCT.Console.Config.DocumentFolders
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DocumentFolderCreator
    {
        private readonly IOffice365Adapter _office365Adapter;
        private readonly ILogger _logger;

        public DocumentFolderCreator(IOffice365Adapter adapter, ILogger logger)
        {
            _office365Adapter = adapter;
            _logger = logger;
        }

        public void CreateFolderIfNotExists(string folderName)
        {
            _logger.LogInformation("Checking if folder {0} exists", folderName);
            if (!_office365Adapter.DoesLibraryExist(folderName))
            {
                _logger.LogInformation("Folder {0} not found. Creating...", folderName);
                _office365Adapter.CreateLibrary(folderName);
            }
            else
            {
                _logger.LogInformation("Folder {0} already exists", folderName);
            }
        }

        public bool CanConnectToSharePoint(string folderName)
        {
            try
            {
                return _office365Adapter.DoesLibraryExist(folderName);
            }
            catch (Exception ex)
            {
                _logger.LogError(1, ex.Message);
                return false;
            }
        }
    }
}