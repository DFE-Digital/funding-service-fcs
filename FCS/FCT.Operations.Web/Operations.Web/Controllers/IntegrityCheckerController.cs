namespace Operations.Web.Controllers
{
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web.Http;
    using Operations.Web.Services;

    [RoutePrefix("integrity-checker")]
    public class IntegrityCheckerController : ApiController
    {
        private readonly IIntegrityCheckerService _integrityCheckerService;

        public IntegrityCheckerController(IIntegrityCheckerService integrityCheckerService)
        {
            _integrityCheckerService = integrityCheckerService;
        }

        [HttpPost, Route]
        public async Task<HttpResponseMessage> StartIntegrityChecker([FromBody] string integrityCheckerName)
        {
            await _integrityCheckerService.StartIntegrityChecker(integrityCheckerName);

            return new HttpResponseMessage(HttpStatusCode.Accepted);
        }

        [HttpPost, Route("all")]
        public async Task<HttpResponseMessage> StartPostMonthEndIntegrityChecks()
        {
            await _integrityCheckerService.StartPostMonthEndIntegrityChecks();

            return new HttpResponseMessage(HttpStatusCode.Accepted);
        }
    }
}