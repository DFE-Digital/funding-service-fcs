namespace SFA.FCT.DocumentsDomain.Integration
{
    using System.Collections.Generic;
    using Microsoft.WindowsAzure.Storage.Blob;
    using Common.Models;

    public interface IAzureStorageWrapper
    {
        CloudBlockBlob GetBlockBlob(FctFile file);

        byte[] GetBlockBlobContents(FctFile file);

        void PutBlockBlob(FctFile file, byte[] contents);

        void DeleteBlockBlob(FctFile file);

        bool DoesBlockBlobExist(FctFile file);

        void CopyBlockBlob(FctFile sourcefile, FctFile targetFile);

        string[] GetContainerContents(string containerName);
    }
}
