namespace SFA.FCT.ContractManagementService.Controllers.FundingConfigService
{
    using System;
    using System.Threading.Tasks;
    using global::ContractManagementService.Repositories;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;

    [Route("rest/referencedatalookup")]
    [Authorize]
    [ApiController]
    public class ReferenceDataLookupApiController : ControllerBase
    {
        private readonly ICrmConfigurationRepository _crmConfigurationRepository;

        public ReferenceDataLookupApiController(ICrmConfigurationRepository crmConfigurationRepository)
        {
            _crmConfigurationRepository = crmConfigurationRepository;
        }

        [HttpGet]
        public async Task<ActionResult> GetLookupData(string period, string periodType, string fundingType, string fundingStreamPeriod)
        {
            try
            {
                if (string.IsNullOrEmpty(fundingStreamPeriod))
                {
                    var fundingConfigurationType = await _crmConfigurationRepository.GetFundingConfiguration(period, periodType, fundingType);
                    return Ok(fundingConfigurationType);
                }

                var deliverableConfiguration = await _crmConfigurationRepository.GetDeliverableConfiguration(fundingStreamPeriod);
                return Ok(deliverableConfiguration);
            }
            catch (Exception ex)
            {
               return BadRequest(ex.Message);
            }
        }
    }
}