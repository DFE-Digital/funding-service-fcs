namespace Operations.Web.Controllers
{
    using System.Threading.Tasks;
    using System.Web.Http;
    using Services;
    using System.Security.Claims;
    using System.Linq;

    [RoutePrefix("fcs-levy-contracts")]
    public class LevyContractController : ApiController
    {
        private readonly ILevyContractService _levyContractService;

        public LevyContractController(ILevyContractService levyContractService)
        {
            _levyContractService = levyContractService;
        }

        [HttpGet, Route("not-amendable")]  
        public IHttpActionResult GetLevyContractsThatCannotBeAmended()
        {
            var levyContractsThatCannotBeAmended = _levyContractService.GetLevyContractsThatCannotBeAmended();

            return Ok(levyContractsThatCannotBeAmended);
        }
        [HttpGet, Route("webjobstatus")]

        public async Task<IHttpActionResult> Webjobstatus()
        {
            var levyContractsThatCannotBeAmended = await _levyContractService.GetEngagementWatcherWebJobStatus();

            return Ok(levyContractsThatCannotBeAmended);
        }
        [HttpPost, Route("enablewebjob")]

        public IHttpActionResult Enablewebjob()
        {
            var user = User.Identity.Name;
            bool enabled = true;
            _levyContractService.UpdateStatusOfEngagementWatcherWebJobStatus(enabled, user);
             return Ok(Task.CompletedTask);
        }
        [HttpPost, Route("disablewebjob")]

        public IHttpActionResult Disablewebjob()
        {
            var user = User.Identity.Name;
            bool enabled = false;
            _levyContractService.UpdateStatusOfEngagementWatcherWebJobStatus(enabled, user); 
            return Ok(Task.CompletedTask);
        }

        [HttpGet, Route("is-authorized")]
        public async Task<IHttpActionResult> IsAuthorizedToInitiatePublication()
        {
            var user = RequestContext.Principal as ClaimsPrincipal;
            var groupStringValue = System.Configuration.ConfigurationManager.AppSettings["FcsUserGroup"];

            var groupClaims = user.FindAll("groups").ToList();
 
            var sequence = 1;
            foreach (var claim in ClaimsPrincipal.Current.FindAll("groups"))
            {
              sequence++;
            }
            await Task.Delay(1);
            return Ok(groupClaims.Any(claim => claim.Value == groupStringValue));
        }
    }
}