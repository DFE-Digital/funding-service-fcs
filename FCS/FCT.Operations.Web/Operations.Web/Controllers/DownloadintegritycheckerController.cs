namespace Operations.Web.Controllers
{
    using System;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using System.Web.Http;
    using Operations.Web.Dtos;
    using Operations.Web.Repositories;

    [RoutePrefix("intcheck-download")]
    public class DownloadintegritycheckerController : ApiController
    {
        private readonly IDownloadIntegrityCheckerRepository _downloadIntegrityCheckerRepository;
        private const int PageSize = 10;

        public DownloadintegritycheckerController(IDownloadIntegrityCheckerRepository downloadIntegrityCheckerRepository)
        {
            _downloadIntegrityCheckerRepository = downloadIntegrityCheckerRepository;
        }

        [HttpGet, Route("download-int-collections")]
        
        public async Task<IHttpActionResult> GetClosedCollections(int pageNumber)
        {
            var startRow = (pageNumber - 1) * PageSize;

            var downloadIntegrityCheckerCollections = await _downloadIntegrityCheckerRepository.GetClosedCollectionsDesc();
            var totalRowsInTable = downloadIntegrityCheckerCollections.FirstOrDefault()?.TotalRowsInTable ?? 0;
           DownloadIntegrityCheckerCollectionResult result = new DownloadIntegrityCheckerCollectionResult(totalRowsInTable, downloadIntegrityCheckerCollections);

            return Ok(result);
        }


        [HttpGet, Route("{download-document}")]
        public async Task<HttpResponseMessage> DownloadDocument(string documentName)
        {
            var attachment = await _downloadIntegrityCheckerRepository.GetAttachmentAsync(documentName);
            var removePath = documentName.Substring(documentName.IndexOf("/", documentName.IndexOf("/", StringComparison.Ordinal) + 1, StringComparison.Ordinal) + 1);

            var result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new ByteArrayContent(attachment)
            };
            result.Content.Headers.ContentDisposition =
                new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment")
                {
                    FileName = removePath
                };
           result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
           

            return result;



        }
    }
}