namespace Operations.Web.Controllers
{
    using System.Linq;
    using System.Threading.Tasks;
    using System.Web.Http;
    using Dtos;
    using Repositories;

    [RoutePrefix("cfs-import")]
    public class CfsImportInfoController : ApiController
    {
        private readonly ICfsImportInfoRepository _cfsImportInfoRepository;
        private const int PageSize = 10;

        public CfsImportInfoController(ICfsImportInfoRepository cfsImportInfoRepository)
        {
            _cfsImportInfoRepository = cfsImportInfoRepository;
        }

        [HttpGet, Route("infos")]
        public async Task<IHttpActionResult> GetClosedCollections(int pageNumber)
        {
            var startRow = (pageNumber - 1) * PageSize;

            var cfsImportInfos = await _cfsImportInfoRepository.GetCfsImportInfos(startRow, PageSize);
            var totalRowsInTable = cfsImportInfos.FirstOrDefault()?.TotalRowsInTable ?? 0;
            var cfsImportInfoResult = new CfsImportInfoResult(totalRowsInTable, cfsImportInfos);

            return Ok(cfsImportInfoResult);
        }

    }
}