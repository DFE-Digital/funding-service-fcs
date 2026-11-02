namespace SFA.FCT.DocumentsDomain.Integration
{
    using Common.Models;

    public class DocumentRepository : IDocumentRepository
    {
        private IAzureStorageWrapper _azureStorageWrapper;

        public DocumentRepository(IAzureStorageWrapper azureStorageWrapper)
        {
            _azureStorageWrapper = azureStorageWrapper;
        }

        public byte[] GetDocument(FctFile file)
        {
            return _azureStorageWrapper.GetBlockBlobContents(file);
        }

        public void CopyDocument(FctFile sourceFile, FctFile targetFile)
        {
            _azureStorageWrapper.CopyBlockBlob(sourceFile, targetFile);
        }

        public void SaveDocument(FctFile file, byte[] document)
        {
            _azureStorageWrapper.PutBlockBlob(file, document);
        }

        public bool FileExists(FctFile file)
        {
            return _azureStorageWrapper.DoesBlockBlobExist(file);
        }

        public void DeleteFile(FctFile file)
        {
            _azureStorageWrapper.DeleteBlockBlob(file);
        }
    }
}
