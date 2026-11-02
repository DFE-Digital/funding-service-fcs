namespace Operations.Web.Controllers
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Web.Http;
    using Dtos;
    using Repositories;

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

            var downloadIntegrityCheckerCollections = await _downloadIntegrityCheckerRepository.GetClosedCollectionsDesc(startRow, PageSize);
            var totalRowsInTable = downloadIntegrityCheckerCollections.FirstOrDefault()?.TotalRowsInTable ?? 0;
            DownloadIntegrityCheckerCollectionResult result = new DownloadIntegrityCheckerCollectionResult(totalRowsInTable, downloadIntegrityCheckerCollections);

            return Ok(result);
        }
    }
}