using Azure.Storage.Blobs;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Azure;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;


namespace FCS.Worker.Azure.Functions.Services
{
    public class BlobService : IBlobService
    {
        private readonly FCTOptions _configVariables;
        private readonly ILogger _log;

        public BlobService(IOptions<FCTOptions> fct, ILogger log)
        {
            _configVariables = fct.Value;
            _log = log;
        }

        public async Task<string> UploadFileAsync(IFormFile file, string container)
        {
            _log.LogInformation("logging the storage connection for testing", _configVariables.AzureWebJobsStorage);
            var blobServiceClient = new BlobServiceClient(_configVariables.AzureWebJobsStorage);
            var blobContainerClient = blobServiceClient.GetBlobContainerClient(container);
            var blobClient = blobContainerClient.GetBlobClient(file.FileName);

            Stream myBlob = new MemoryStream();
            myBlob = file.OpenReadStream();
            await blobClient.UploadAsync(myBlob, overwrite: true);
            myBlob.Close();

            return blobClient.Uri.ToString(); // Return the file URL
        }
    }
}
