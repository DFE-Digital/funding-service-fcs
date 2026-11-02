namespace Operations.Web.Controllers
{
    using System;
    using System.Threading.Tasks;
    using System.Web.Http;
    using Dtos;
    using Services;

    [RoutePrefix("availability")]
    public class AvailabilityController : ApiController
    {
        private readonly IAvailabilityCheckerService _availabilityCheckerService;

        public AvailabilityController(IAvailabilityCheckerService availabilityCheckerService)
        {
            _availabilityCheckerService = availabilityCheckerService;
        }

        [HttpGet, Route("services")]
        public IHttpActionResult GetCheckers()
        {
            return Ok(_availabilityCheckerService.GetAvailabilityCheckerServiceNames());
        }

        [HttpGet, Route("services/{serviceName}")]
        public async Task<IHttpActionResult> GetCheckResult(string serviceName)
        {
            AvailabilityCheckResult result = await _availabilityCheckerService.GetAvailabilityCheckResultForService(serviceName);

            if (result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }
   }
}
