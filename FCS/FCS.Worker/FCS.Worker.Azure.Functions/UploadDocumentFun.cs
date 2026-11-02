using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Configuration;
using Azure.Storage.Blobs;
using System.Text.Json.Nodes;
using System.Diagnostics;
using System.Linq.Expressions;
using System.Linq;
using FCS.Worker.Azure.Functions.Services;


namespace FCS.Worker.Azure.Functions
{
    public class UploadDocumentFun
    {
        private readonly IBlobService _blobService;
        private readonly ILogger _log;

        // private readonly MyOptions _settings;
        public UploadDocumentFun(IBlobService blobService, ILogger log)
        {
            _log = log;
            _blobService = blobService;
        }


        [FunctionName("UploadDocumentFun")]
        [FixedDelayRetry(3, "00:00:05")] // Retries 3 times with a 5-second delay
        public async Task<IActionResult> Run(
         [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)] HttpRequest req)
        {
            try
            {
                _log.LogInformation("Function started processing the document upload request");
                var file = req.Form.Files["file"];
                var container = req.Form["containerName"];

                var fileUrl = await _blobService.UploadFileAsync(file, container);

                _log.LogInformation("Function processed successfully");

                // Always return the file URL
                return new JsonResult(new { FileUrl = fileUrl });
            }
            catch (Exception e)
            {
                _log.LogError(e, "An error occurred while uploading the file.");
                return new JsonResult(new { error = "Something went wrong, try uploading again.." }) { StatusCode = StatusCodes.Status500InternalServerError };
            }
        }

    }

}

