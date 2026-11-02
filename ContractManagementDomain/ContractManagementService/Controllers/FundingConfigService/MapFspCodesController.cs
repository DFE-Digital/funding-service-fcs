using ContractManagementService.DTOs;
using ContractManagementService.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace ContractManagementService.Controllers.FundingConfigService
{
    [Route("api/configuration")]
    [Authorize]
    [ApiController]
    public class MapFspCodesController(IFundingStreamPeriodCodeService fundingStreamPeriodCodeService)
        : ControllerBase
    {
        [HttpGet("fspcodes")]
        public async Task<ActionResult<FundingStreamPeriodCodesResponse>> MapFspCodes(
            [FromQuery(Name = "allocationFundingStreamCode")] string allocationFundingStreamCode,
            [FromQuery(Name = "allocationPeriodCode")] string allocationPeriodCode)
        {
            if (string.IsNullOrWhiteSpace(allocationFundingStreamCode) ||
                string.IsNullOrWhiteSpace(allocationPeriodCode))
            {
                return BadRequest("allocationFundingStreamCode and allocationPeriodCode are required.");
            }

            var codes = await fundingStreamPeriodCodeService.GetFundingStreamPeriodCodesAsync(
                allocationFundingStreamCode,
                allocationPeriodCode);

            return Ok(new FundingStreamPeriodCodesResponse
            {
                FundingStreamPeriodCodes = codes
            });
        }
    }
}
