namespace OrganisationDomain.Web.Controllers
{
    using Microsoft.AspNetCore.Http;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.Extensions.Configuration;
    using NServiceBus;
    using OrganisationDomain.Integration.Messages.Messages;
    using OrganisationDomain.Integration.Messages.Messages.Expires;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using System;
    using System.Threading.Tasks;

    [ApiController]
    [Route("api/v1")]
    public class OrganisationApiController : ControllerBase
    {
        private readonly ILocalOrganisationRetriever _localOrganisationRetriever;
        private readonly IConfiguration _configuration;

        private bool HasTimeoutOccurred { get; set; }

        public OrganisationApiController(
            ILocalOrganisationRetriever localOrganisationRetriever,
            IConfiguration configuration)
        {
            _localOrganisationRetriever = localOrganisationRetriever;
            _configuration = configuration;
        }

        [HttpGet("organisations/ukprn/{ukprn}")]
        public async Task<IActionResult> GetOrganisationByUkPrn(int ukprn)
        {
            organisation org = _localOrganisationRetriever.GetOrganisationFromLocalDb(ukprn);

            if (org == null)
            {
                var request = new GetOrganisationRequest
                {
                    Ukprn = ukprn
                };

                var response = await GetOrganisation(request);

                if (HasTimeoutOccurred)
                {
                    return StatusCode(
                        StatusCodes.Status504GatewayTimeout,
                        "The organisation service did not respond in a timely manner");
                }

                if (response != null)
                {
                    if (response.DuplicatesFound)
                    {
                        return BadRequest(
                            "Could not resolve duplicate UKPRNs for this provider");
                    }

                    if (response.OrganisationXmlIsInvalidAgainstSchema)
                    {
                        return StatusCode(
                            StatusCodes.Status500InternalServerError,
                            "An internal error with the organisation service has been identified and passed to support to investigate. Please contact support for more information.");
                    }

                    if (response.Organisation != null)
                    {
                        org = response.Organisation;
                    }
                }
            }

            if (org == null)
            {
                return NotFound();
            }

            return Ok(org);
        }

        [HttpGet("organisations/{organisationId}")]
        public async Task<IActionResult> GetOrganisationById(string organisationId)
        {
            var request = new GetOrganisationRequest
            {
                OrganisationId = organisationId
            };

            var response = await GetOrganisation(request);

            if (HasTimeoutOccurred)
            {
                return StatusCode(
                    StatusCodes.Status504GatewayTimeout,
                    "The organisation service did not respond in a timely manner");
            }

            if (response == null || response.Organisation == null)
            {
                return NotFound();
            }

            return Ok(response.Organisation);
        }

        [HttpGet("test")]
        public IActionResult Test()
        {
            return Ok();
        }

        private async Task<GetOrganisationResponse> GetOrganisation(GetOrganisationRequest request)
        {
            HasTimeoutOccurred = false;

            try
            {
                await ServiceBus.Bus.Send(request);

                return null;
            }
            catch
            {
                HasTimeoutOccurred = true;
                throw;
            }
        }
    }
}