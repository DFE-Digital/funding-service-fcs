namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Diagnostics.Contracts;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;

    public static class AzureStorageWrapper
    {
        public static IList<string> GetBlobsInContainer(string containerName)
        {
            return GetContainer(containerName)
                .ListBlobsSegmentedAsync(null, true, BlobListingDetails.None, null, null, null, null)
                .GetAwaiter().GetResult()
                .Results
                .OfType<CloudBlockBlob>()
                .Select(b => b.Name)
                .ToList();
        }

        public static IReadOnlyCollection<BlobInfo> GetBlobInfosInContainerAfterDate(string containerName, DateTime startDateTime)
        {
            return GetContainer(containerName)
                .ListBlobsSegmentedAsync(null, true, BlobListingDetails.None, null, null, null, null)
                .GetAwaiter().GetResult()
                .Results
                .OfType<CloudBlockBlob>()
                .Where(cbb => startDateTime < cbb.Properties?.LastModified)
                .Select(b => new BlobInfo(b.Name, b.Properties.LastModified?.DateTime))
                .OrderByDescending(b => b.LastModified)
                .ToList();
        }

        public static IReadOnlyCollection<BlobInfo> GetBlobInfosInContainerOnDate(string containerName, DateTime dateTime)
        {
            return GetContainer(containerName)
                .ListBlobsSegmentedAsync(null, true, BlobListingDetails.None, null, null, null, null)
                .GetAwaiter().GetResult()
                .Results
                .OfType<CloudBlockBlob>()
                .Where(cbb => cbb.Properties?.LastModified != null && dateTime.Date == cbb.Properties.LastModified.Value.Date)
                .Select(b => new BlobInfo(b.Name, b.Properties.LastModified?.DateTime))
                .OrderByDescending(b => b.LastModified)
                .ToList();
        }

        public static CloudBlockBlob GetBlockBlob(FctFile file)
        {
            Contract.Requires(file != null);

            CloudBlobContainer container = GetContainer(file.FileContainer);
            CloudBlockBlob blockBlob = container.GetBlockBlobReference(file.Filename);

            return blockBlob;
        }

        public static DateTime GetBlockBlobLastUpdateTimestamp(FctFile file)
        {
            Contract.Requires(file != null);

            var blockBlob = GetBlockBlob(file);
                blockBlob.FetchAttributesAsync().GetAwaiter().GetResult();
            return blockBlob.Properties.LastModified.HasValue ? blockBlob.Properties.LastModified.Value.UtcDateTime : DateTime.MinValue;
        }

        public static byte[] GetBlockBlobContents(FctFile file)
        {
            Contract.Requires(file != null);

            byte[] blobContents;
            CloudBlockBlob blockBlob = GetBlockBlob(file);

            using (MemoryStream blobStream = new MemoryStream())
            {
                blockBlob.DownloadToStreamAsync(blobStream).GetAwaiter().GetResult();
                blobContents = blobStream.ToArray();
            }

            return blobContents;            
        }

        public static BlobContents GetBlobContents(FctFile file)
        {
            Contract.Requires(file != null);

            byte[] blobContents;
            CloudBlockBlob blockBlob = GetBlockBlob(file);

            using (MemoryStream blobStream = new MemoryStream())
            {
                blockBlob.DownloadToStreamAsync(blobStream).GetAwaiter().GetResult();
                blobContents = blobStream.ToArray();
            }


            return new BlobContents(etag: blockBlob.Properties.ETag, contents: blobContents);
        }

        public static string GetBlockBlobContentsAsString(FctFile file)
        {
            Contract.Requires(file != null);

            CloudBlockBlob blockBlob = GetBlockBlob(file);
            // Fix: Use DownloadTextAsync instead of non-existent DownloadText
            return blockBlob.DownloadTextAsync(Encoding.UTF8, null, null, null).GetAwaiter().GetResult();
        }

        public static byte[][] GetBlockBlobContents(List<FctSourceFile> files)
        {
            Contract.Requires(files != null);

            List<byte[]> completeBlobContents = new List<byte[]>();
            byte[] blobContents;

            foreach (FctSourceFile file in files)
            {
                CloudBlockBlob blockBlob = GetBlockBlob(new FctFile(file.FileContainer, file.Filename));

                using (MemoryStream blobStream = new MemoryStream())
                {
                    blockBlob.DownloadToStreamAsync(blobStream).GetAwaiter().GetResult();
                    blobContents = blobStream.ToArray();
                }

                completeBlobContents.Add(blobContents);
            }

            return completeBlobContents.ToArray();
        }

        public static void PutBlockBlob(FctFile file, byte[] contents)
        {
            Contract.Requires(file != null);

            CloudBlockBlob blockBlob = GetBlockBlob(file);

            // Fix: Use UploadFromByteArrayAsync instead of non-existent UploadFromByteArray
            blockBlob.UploadFromByteArrayAsync(contents, 0, contents.Length).GetAwaiter().GetResult();
        }

        public static void PutBlockBlob(FctFile file, byte[] contents, string etag)
        {
            Contract.Requires(file != null);

            CloudBlockBlob blockBlob = GetBlockBlob(file);

            // Fix: Use UploadFromByteArrayAsync with AccessCondition
            blockBlob.UploadFromByteArrayAsync(
                contents,
                0,
                contents.Length,
                accessCondition: AccessCondition.GenerateIfMatchCondition(etag),
                options: null,
                operationContext: null
            ).GetAwaiter().GetResult();
        }

        public static void DeleteBlockBlob(FctFile file)
        {
            Contract.Requires(file != null);

            CloudBlockBlob fileBlob = GetBlockBlob(file);
            fileBlob.DeleteIfExistsAsync().GetAwaiter().GetResult();
        }

        public static bool DoesBlockBlobExist(FctFile file)
        {
            Contract.Requires(file != null);

            // Fix: Use ExistsAsync().GetAwaiter().GetResult() instead of Exists()
            return GetBlockBlob(file).ExistsAsync().GetAwaiter().GetResult();
        }

        public static void CopyBlockBlob(FctFile sourcefile, FctFile targetFile)
        {
            Contract.Requires(sourcefile != null);
            Contract.Requires(targetFile != null);

            CloudBlockBlob sourceBlockBlob = GetBlockBlob(sourcefile);
            CloudBlockBlob targetBlockBlob = GetBlockBlob(targetFile);

            // Start the copy process using StartCopyAsync
            targetBlockBlob.StartCopyAsync(sourceBlockBlob).GetAwaiter().GetResult();

            // Refresh attributes to get the latest copy state
            targetBlockBlob.FetchAttributesAsync().GetAwaiter().GetResult();

            // Check progress to see if it is done
            while (targetBlockBlob.CopyState != null && targetBlockBlob.CopyState.Status == CopyStatus.Pending)
            {
                Task.Delay(TimeSpan.FromSeconds(5d)).Wait();
                targetBlockBlob.FetchAttributesAsync().GetAwaiter().GetResult();
            }
        }

        public static void CreateIfNotExists(string containerName)
        {
            // Fix: Use CreateIfNotExistsAsync().GetAwaiter().GetResult() instead of CreateIfNotExists
            GetContainer(containerName).CreateIfNotExistsAsync().GetAwaiter().GetResult();
        }

        public static void CreateIfNotExists(string containerName, string storageConnectionString)
        {
            // Fix: Use CreateIfNotExistsAsync().GetAwaiter().GetResult() instead of CreateIfNotExists
            GetContainer(containerName, storageConnectionString).CreateIfNotExistsAsync().GetAwaiter().GetResult();
        }

        private static CloudBlobContainer GetContainer(string containerName)
        {
            var storageConnectionString = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;

            return GetContainer(containerName, storageConnectionString);
        }

        private static CloudBlobContainer GetContainer(string containerName, string storageConnectionString)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(storageConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(containerName);

            return container;
        }
    }

    public class BlobContents
    {
        public BlobContents(string etag, byte[] contents)
        {
            Etag = etag;
            Contents = contents;
        }

        public string Etag { get; }

        public byte[] Contents { get; }
    }
}
