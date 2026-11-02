namespace SFA.FCT.DocumentsDomain.Integration
{
    using System;
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using System.IO;
    using System.Linq;
    using System.Threading.Tasks;
    using Common.Models;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;

    [ExcludeFromCodeCoverage]
    public class AzureStorageWrapper : IAzureStorageWrapper
    {
        public CloudBlobContainer GetContainer(string containerName)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(containerName);
            return container;
        }

        public CloudBlockBlob GetBlockBlob(FctFile file)
        {
            return GetContainer(file.FileContainer).GetBlockBlobReference(file.Filename);
        }

        public byte[] GetBlockBlobContents(FctFile file)
        {
            byte[] blobContents;
            CloudBlockBlob blockBlob = GetBlockBlob(file);

            using (MemoryStream blobStream = new MemoryStream())
            {
                blockBlob.DownloadToStream(blobStream);
                blobContents = blobStream.ToArray();
            }

            return blobContents;            
        }

        public void PutBlockBlob(FctFile file, byte[] contents)
        {
            CloudBlockBlob blockBlob = GetBlockBlob(file);

            blockBlob.UploadFromByteArray(contents, 0, contents.Length);    
        }

        public void DeleteBlockBlob(FctFile file)
        {
            CloudBlockBlob fileBlob = GetBlockBlob(file);
            fileBlob.DeleteIfExists();
        }

        public bool DoesBlockBlobExist(FctFile file)
        {
            return GetBlockBlob(file).Exists();
        }

        public void CopyBlockBlob(FctFile sourcefile, FctFile targetFile)
        {
            CloudBlockBlob sourceBlockBlob = GetBlockBlob(sourcefile);
            CloudBlockBlob targetBlockBlob = GetBlockBlob(targetFile);

            // Start the copy process
            targetBlockBlob.StartCopyFromBlob(sourceBlockBlob);

            // Check progress to see if it is done
            while (targetBlockBlob.CopyState.Status == CopyStatus.Pending)
            {
                Task.Delay(TimeSpan.FromSeconds(5d)).Wait();
            }
        }

        public string[] GetContainerContents(string containerName)
        {
            return 
                GetContainer(containerName)
                .ListBlobs()
                .Where(b => b.GetType() == typeof(CloudBlockBlob))
                .Select(b => ((CloudBlockBlob)b).Name)
                .ToArray();
        }
    }
}
