namespace Operations.Web.Controllers
{
    using System.Linq;
    using System.Threading.Tasks;
    using System.Web.Http;
    using Dtos;
    using Repositories;

    [RoutePrefix("month-end")]
    public class MonthEndInfoController : ApiController
    {
        private readonly IClosedCollectionRepository _closedCollectionRepository;
        private const int PageSize = 10;

        public MonthEndInfoController(IClosedCollectionRepository closedCollectionRepository)
        {
            _closedCollectionRepository = closedCollectionRepository;
        }

        [HttpGet, Route("closed-collections")]
        public async Task<IHttpActionResult> GetClosedCollections(int pageNumber)
        {
            var startRow = (pageNumber - 1) * PageSize;

            var closedCollections = await _closedCollectionRepository.GetClosedCollectionsDesc(startRow, PageSize);
            var totalRowsInTable = closedCollections.FirstOrDefault()?.TotalRowsInTable ?? 0;
            ClosedCollectionResult result = new ClosedCollectionResult(totalRowsInTable, closedCollections);

            return Ok(result);
        }
    }
}