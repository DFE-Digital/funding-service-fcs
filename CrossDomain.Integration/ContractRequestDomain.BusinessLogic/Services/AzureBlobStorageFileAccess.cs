namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System.Collections.Generic;
    using System.IO;
    using System.Text;
    using CrossDomain.Integration.Common.Storage;
    using Interfaces;
    using Common.Utils;
    using System;

    public class AzureBlobStorageFileAccess : IBulkUploadFileAccess
    {
        private readonly string _dropFolder = ConfigurationHelper.GetSetting(ConfigurationHelper.FileWatcherDropFolder);
        private readonly string _processedFolder = ConfigurationHelper.GetSetting(ConfigurationHelper.FileWatcherProcessedFolder); 

        public IList<string> GetNewFiles()
        {
            return AzureStorageWrapper.GetBlobsInContainer(_dropFolder);
        }

        public System.DateTime GetFileTimestamp(string file)
        {
            return AzureStorageWrapper.GetBlockBlobLastUpdateTimestamp(new FctFile(_dropFolder, file));
        }

        public byte[] GetBulkUploadFileContents(string file)
        {
            FctFile fctFile = new FctFile(_dropFolder, file);
            return AzureStorageWrapper.GetBlockBlobContents(fctFile);
        }

        public byte[] GetProcessingFileContents(string file)
        {
            FctFile fctFile = new FctFile(_processedFolder, file);
            return AzureStorageWrapper.GetBlockBlobContents(fctFile);
        }

        public void MarkFileAsRetrieved(string file)
        {
            FctFile fctFile = new FctFile(_dropFolder, file);
            FctFile fctProcessedFile = new FctFile(_processedFolder, file);
            AzureStorageWrapper.CopyBlockBlob(fctFile, fctProcessedFile);
            AzureStorageWrapper.DeleteBlockBlob(fctFile);
        }

        public void UnmarkFileAsRetrieved(string file)
        {
            FctFile fctFile = new FctFile(_dropFolder, file);
            FctFile fctProcessedFile = new FctFile(_processedFolder, file);
            AzureStorageWrapper.CopyBlockBlob(fctProcessedFile, fctFile);
            AzureStorageWrapper.DeleteBlockBlob(fctProcessedFile);
        }

        public void CreateSyntaxReport(string originalFile, string contents)
        {
            string reportFileName = Path.Combine(originalFile + ".Syntax Report.txt");
            AzureStorageWrapper.PutBlockBlob(new FctFile(_processedFolder, reportFileName), Encoding.UTF8.GetBytes(contents));
        }

        public string CreateResultsReport(string originalFile, byte[] contents)
        {
            string reportFileName = Path.Combine(originalFile + ".Results Report.xlsx");
            AzureStorageWrapper.PutBlockBlob(new FctFile(_processedFolder, reportFileName), contents);
            return reportFileName;
        }

        public bool DoesFileExistInProcessing(string fileName)
        {
            throw new NotImplementedException();
        }

        public bool DoesFileExistInProcessedFolder(string fileName)
        {
            throw new NotImplementedException();
        }

        public bool DoesFileExistInInputFolder(string fileName)
        {
            throw new NotImplementedException();
        }

        public void MoveRejectedFileFromProcessingToProcessed(string originalFileName, FileRejectionReason reason)
        {
            throw new NotImplementedException();
        }

        public void MoveRejectedFileFromInputToProcessed(string originalFileName, FileRejectionReason reason)
        {
            throw new NotImplementedException();
        }

        public void MoveRejectedFileFromProcessing(string originalFileName, string rejectedFileName)
        {
            throw new NotImplementedException();
        }
    }
}
