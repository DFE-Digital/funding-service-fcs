using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using Operations.Web.Services;

namespace Operations.Web.Controllers
{
    [RoutePrefix("contractcleanup")]
    public class ContractDataController : ApiController
    {
        private readonly IContractCleanupService _contractCleanupService;

        public ContractDataController(IContractCleanupService contractCleanupService)
        {
            _contractCleanupService = contractCleanupService;
        }
        [HttpPost, Route("cfsdata")]
        public async Task<IHttpActionResult> CleanContractData(List<string> FundingIds)
        {
            string result = await _contractCleanupService.CleanContractData(FundingIds);

            if (result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }
    }
}
