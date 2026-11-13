namespace Operations.Web.Controllers
{
    using Azure.Storage.Blobs;
    using Azure.Storage.Sas;
    using ClosedXML.Excel;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using Newtonsoft.Json;
    using Operations.Web.Dtos;
    using Operations.Web.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web.Http;
    using System.Web.Http.Results;



    [RoutePrefix("applevy-variation")]
    public class AppLevyController : ApiController
    {
        private readonly IAppLevyService _appLevyService;
        private readonly ILogger _logger;
        private readonly string _uploadDocumentFunUrl;
        private readonly CloudTable _table;
        private readonly IAzureTableService _azureTableService;
        private readonly string _connectionString;
        private readonly string _commonconnectionString;
        string environment = ConfigurationManager.AppSettings["StorageTableSuffix"];
        string destinationContainer = ConfigurationManager.AppSettings["DestinationContainer"];
        public AppLevyController(IAppLevyService appLevyService, ILogger logger, CloudTable table, IAzureTableService azureTableService)
        {
            _appLevyService = appLevyService;
            _logger = logger;
            _table = table;
            _uploadDocumentFunUrl = ConfigurationManager.AppSettings["UploadDocumentFunUrl"];
            _connectionString = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;
            _commonconnectionString = ConfigurationManager.ConnectionStrings["CommonStorageConnectionString"].ConnectionString;
            _azureTableService = azureTableService;
        }

        [HttpGet, Route("{GetFiles}/{container}")]
        public async Task<IHttpActionResult> GetFiles(string container)
        {
            if (string.IsNullOrWhiteSpace(container))
            {
                return BadRequest("Container name is required.");
            }

            try
            {
                var files = await _appLevyService.GetFilesAsync(container);
                if (files != null)
                {
                    return Ok(files);
                }
                return NotFound();
            }
            catch (Exception ex)
            {
                _logger.LogError(1, "An error occurred while fetching files from container: {Container}", ex, container);
                return InternalServerError(ex);
            }
        }


        [HttpPost, Route("copyDocuments")]
        public async Task<IHttpActionResult> CopyDocuments([FromBody] CopyDocumentsRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.SourceContainer))
            {
                return BadRequest("Source container is required.");
            }

            if (string.IsNullOrWhiteSpace(destinationContainer))
            {
                return InternalServerError(new Exception("Destination container is not configured."));
            }

            try
            {
                var sourceBlobServiceClient = new BlobServiceClient(_commonconnectionString);
                var destinationBlobServiceClient = new BlobServiceClient(_connectionString);

                var sourceContainerClient = sourceBlobServiceClient.GetBlobContainerClient(request.SourceContainer);
                var destinationContainerClient = destinationBlobServiceClient.GetBlobContainerClient(destinationContainer + environment.ToLower());

                var blobs = sourceContainerClient.GetBlobs().ToList();
                foreach (var blobItem in blobs)
                {
                    var sourceBlobClient = sourceContainerClient.GetBlobClient(blobItem.Name);
                    var destinationBlobClient = destinationContainerClient.GetBlobClient(blobItem.Name);


                    var sasToken = sourceBlobClient.GenerateSasUri(BlobSasPermissions.Read, DateTimeOffset.UtcNow.AddHours(1)).Query;
                    var sourceBlobUriWithSas = new Uri(sourceBlobClient.Uri + "?" + sasToken);


                    _logger.LogInformation($"Source Blob URI with SAS: {sourceBlobUriWithSas}");

                    await destinationBlobClient.StartCopyFromUriAsync(sourceBlobUriWithSas);
                }

                return Ok("Documents copied successfully.");
            }
            catch (Exception ex)
            {
                _logger.LogError(1, "An error occurred while copying documents.", ex);
                return InternalServerError(ex);
            }
        }



        [HttpPost, Route("createapplevyvariation")]
        public IHttpActionResult CreateAppLevyVariation([FromBody] List<AppLevyDto> items)
        {
            if (items == null || items.Count == 0)
            {
                return BadRequest("Items are required.");
            }

            foreach (var item in items)
            {
                var validationResults = new List<System.ComponentModel.DataAnnotations.ValidationResult>();
                var validationContext = new ValidationContext(item, null, null);
                if (!Validator.TryValidateObject(item, validationContext, validationResults, true))
                {
                    return BadRequest(string.Join("; ", validationResults.Select(vr => vr.ErrorMessage)));
                }
            }

            try
            {
                _appLevyService.CreateAppLevyVariation(items);
                return Ok();
            }
            catch (Exception ex)
            {
                _logger.LogError(1, "An error occurred while creating App Levy variation.", ex);
                return InternalServerError(ex);
            }
        }


        [HttpPost, Route("UploadDocumentFun")]
        public async Task<IHttpActionResult> UploadDocumentFun()
        {
            if (!Request.Content.IsMimeMultipartContent())
            {
                return BadRequest("Unsupported media type.");
            }

            try
            {
                var provider = new MultipartMemoryStreamProvider();
                await Request.Content.ReadAsMultipartAsync(provider);

                var file = provider.Contents.FirstOrDefault();
                if (file == null)
                {
                    return BadRequest("No file found in the request.");
                }

                var containerName = provider.Contents
                .FirstOrDefault(c => c.Headers.ContentDisposition.Name.Trim('"') == "containerName")?
                .ReadAsStringAsync().Result;

                if (string.IsNullOrWhiteSpace(containerName))
                {
                    return BadRequest("Container name is required.");
                }

                var fileBytes = await file.ReadAsByteArrayAsync();
                var fileName = file.Headers.ContentDisposition.FileName.Trim('"');

                using (var client = new HttpClient())
                {
                    var formData = new MultipartFormDataContent();
                    formData.Add(new ByteArrayContent(fileBytes), "file", fileName);
                    formData.Add(new StringContent(containerName), "containerName");

                    var response = await client.PostAsync(_uploadDocumentFunUrl, formData);
                    if (response.IsSuccessStatusCode)
                    {
                        var fileUrl = await response.Content.ReadAsStringAsync();
                        return Ok(new { FileUrl = fileUrl });
                    }
                    return Content(response.StatusCode, await response.Content.ReadAsStringAsync());
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(1, "An error occurred while uploading the document.", ex);
                return InternalServerError(ex);
            }
        }


        [HttpPost, Route("createRelease")]
        public async Task<IHttpActionResult> CreateRelease([FromBody] ReleaseEntity release)
        {
            if (release == null)
            {
                return BadRequest("Release details are required.");
            }


            if (release.FileUrl.StartsWith("{\"fileUrl\":"))
            {
                var fileUrlObject = JsonConvert.DeserializeObject<Dictionary<string, string>>(release.FileUrl);
                release.FileUrl = fileUrlObject["fileUrl"];
            }


            release.PartitionKey = "APPLEVY";
            release.RowKey = Guid.NewGuid().ToString();
            release.ReleaseId = Guid.NewGuid().ToString();
            release.Environment = ConfigurationManager.AppSettings["StorageTableSuffix"];

            var initialStatuses = new Dictionary<string, string>
             {
             { "OAT", "Not Started" },
             { "PROD", "Not Started" },
             { "DMO", "Not Started" },
             { "DAT", "Not Started" },
             { "DOAT", "Not Started" },
             { "AT", "Not Started" },
             { "DCI", "Not Started" },
             { "CI", "Not Started" },
             { "MO", "Not Started" }
             };
            release.SetEnvironmentStatuses(initialStatuses);


            if (release.PartitionKey.Length > 1024 || release.RowKey.Length > 1024)
            {
                return BadRequest("PartitionKey and RowKey must be within 1024 characters.");
            }

            try
            {
                await _azureTableService.InsertReleaseEntityAsync(release);
                return Ok("Release created successfully.");
            }
            catch (StorageException ex)
            {
                var requestInfo = ex.RequestInformation;
                var extendedErrorInfo = requestInfo.ExtendedErrorInformation;
                var errorMessage = extendedErrorInfo != null ? extendedErrorInfo.ErrorMessage : ex.Message;
                _logger.LogError(1, $"An error occurred while creating the release. Error: {errorMessage}, RequestId: {requestInfo.ServiceRequestID}, StatusCode: {requestInfo.HttpStatusCode}", ex);
                return Content(HttpStatusCode.InternalServerError, $"An error occurred while creating the release. Error: {errorMessage}");
            }
        }

        [HttpGet, Route("getReleases")]
        public async Task<IHttpActionResult> GetReleases()
        {

            try
            {
                var releases = await _azureTableService.GetAllEntitiesAsync();

                var releaseStatusList = releases.Select(release => new
                {
                    release.ReleaseName,
                    release.VersionNumber,
                    release.Description,
                    release.Timestamp,
                    release.FileUrl,
                    release.RowKey,
                    release.Environment,
                    Status = release.GetEnvironmentStatuses()[environment],
                }).OrderByDescending(release => release.Timestamp).ToList();

                return Ok(releaseStatusList);
            }
            catch (Exception ex)
            {
                _logger.LogError(1, $"An error occurred while fetching releases. Error: {ex.Message}", ex);
                return Content(HttpStatusCode.InternalServerError, $"An error occurred while fetching releases. Error: {ex.Message}");
            }
        }

        [HttpPost, Route("deploy")]
        public async Task<IHttpActionResult> Deploy([FromBody] DeployRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.FileUrl))
            {
                return BadRequest("File URL is required.");
            }

            try
            {
                _logger.LogInformation($"Received FileUrl: {request.FileUrl}");

                var releaseEntityUpdate = await _azureTableService.GetReleaseEntityAsync(request.Rowkey);
                await UpdateEntitySync(releaseEntityUpdate, "In-progress");

                var blobServiceClient = new BlobServiceClient(_commonconnectionString);
                var uri = new Uri(request.FileUrl);
                var containerName = uri.Segments[1].Trim('/');
                var blobName = string.Join("/", uri.Segments.Skip(2)).Replace("%20", " ");

                var containerClient = blobServiceClient.GetBlobContainerClient(containerName);
                var blobClient = containerClient.GetBlobClient(blobName);

                _logger.LogInformation($"Blob URI: {blobClient.Uri}");

                var blobStream = await blobClient.OpenReadAsync();
                var fileContent = await ReadStreamAsByteArray(blobStream);

                var items = ParseExcelData(fileContent);
                var result = CreateAppLevyVariation(items);
                if (result is OkResult)
                {
                    await UpdateEntitySync(releaseEntityUpdate, "Deployed");
                    return Ok("Release deployed successfully.");
                }
                else
                {
                    //await UpdateEntitySync(releaseEntityUpdate, "error");
                    return result;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(1, "An error occurred while deploying the release.", ex);
                return InternalServerError(ex);
            }
        }

        private async Task UpdateEntitySync(ReleaseEntity releaseEntity, string status)
        {
            var updateStatuses = releaseEntity.GetEnvironmentStatuses();
            updateStatuses[environment] = status;
            releaseEntity.SetEnvironmentStatuses(updateStatuses);

            await _azureTableService.UpdateReleaseEntityAsync(releaseEntity);
        }


        private async Task<byte[]> ReadStreamAsByteArray(Stream stream)
        {
            using (var memoryStream = new MemoryStream())
            {
                await stream.CopyToAsync(memoryStream);
                return memoryStream.ToArray();
            }
        }

        private List<AppLevyDto> ParseExcelData(byte[] fileContent)
        {
            using (var stream = new MemoryStream(fileContent))
            {
                using (var workbook = new XLWorkbook(stream))
                {
                    var worksheet = workbook.Worksheets.First();
                    var rows = worksheet.RowsUsed().Skip(1);

                    var items = new List<AppLevyDto>();
                    foreach (var row in rows)
                    {
                        var item = new AppLevyDto
                        {
                            ContractNumber = row.Cell(1).GetString(),
                            ContractStatus = row.Cell(2).GetString(),
                            ContractSubStatus = row.Cell(3).GetString(),
                            IsLetterBespoke = row.Cell(4).GetString(),
                            IsTnCBespoke = row.Cell(5).GetString()
                        };
                        items.Add(item);
                    }
                    return items;
                }
            }
        }


        [HttpGet, Route("GetLatestContractInformationByFundingTypeAndFundingPeriod/{fundingType}/{fundingPeriod}")]
        public IHttpActionResult GetLatestContractInformationByFundingTypeAndFundingPeriod(string fundingType, string fundingPeriod)
        {
            try
            {
                var crmData = _appLevyService.GetLatestContractInformationByFundingTypeAndFundingPeriod(fundingType, fundingPeriod);
                return Ok(crmData);
            }
            catch (Exception ex)
            {
                _logger.LogError(1, $"An error occurred while fetching CRM data for funding type {fundingType} and funding period {fundingPeriod}.", ex);
                return InternalServerError(ex);
            }
        }

    }
}

