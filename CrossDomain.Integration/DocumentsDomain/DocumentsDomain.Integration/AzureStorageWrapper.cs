namespace SFA.FCT.DocumentsDomain.Integration
{
    using Common.Models;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Diagnostics.CodeAnalysis;
    using System.IO;
    using System.Linq;
    using System.Threading.Tasks;

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
            CloudBlockBlob blockBlob = GetBlockBlob(file);

            using (var blobStream = new MemoryStream())
            {                
                blockBlob.DownloadToStreamAsync(blobStream).GetAwaiter().GetResult();
                return blobStream.ToArray();
            }
        }

        public void PutBlockBlob(FctFile file, byte[] contents)
        {
            CloudBlockBlob blockBlob = GetBlockBlob(file);
            blockBlob.UploadFromByteArrayAsync(contents, 0, contents.Length)
                     .GetAwaiter().GetResult();
        }


        public void DeleteBlockBlob(FctFile file)
        {
            CloudBlockBlob fileBlob = GetBlockBlob(file);
            fileBlob.DeleteIfExistsAsync()
                    .GetAwaiter().GetResult();
        }
        public bool DoesBlockBlobExist(FctFile file)
        {
            CloudBlockBlob blob = GetBlockBlob(file);
            return blob.ExistsAsync().GetAwaiter().GetResult();
        }

        public void CopyBlockBlob(FctFile sourceFile, FctFile targetFile)
        {
            CloudBlockBlob sourceBlob = GetBlockBlob(sourceFile);
            CloudBlockBlob targetBlob = GetBlockBlob(targetFile);

            targetBlob.StartCopyAsync(sourceBlob).GetAwaiter().GetResult();

            
            CopyState copyState;

            do
            {
                targetBlob.FetchAttributesAsync().GetAwaiter().GetResult();
                copyState = targetBlob.CopyState;

                if (copyState.Status == CopyStatus.Pending)
                {
                    Task.Delay(TimeSpan.FromSeconds(2)).Wait();
                }

            } while (copyState.Status == CopyStatus.Pending);
        }

        public string[] GetContainerContents(string containerName)
        {
            var container = GetContainer(containerName); // returns CloudBlobContainer
            var results = new List<string>();

            BlobContinuationToken token = null;
            do
            {
                var segment = container
                    .ListBlobsSegmentedAsync(
                        prefix: null,
                        useFlatBlobListing: true,
                        blobListingDetails: BlobListingDetails.None,
                        maxResults: null,
                        currentToken: token,
                        options: null,
                        operationContext: null)
                    .GetAwaiter()
                    .GetResult();

                token = segment.ContinuationToken;

                results.AddRange(
                    segment.Results
                           .OfType<CloudBlockBlob>()
                           .Select(b => b.Name));
            } while (token != null);

            return results.ToArray();
        }


    }
}
