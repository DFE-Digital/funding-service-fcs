namespace OrganisationDomain.Web.Controllers
{
    using System;
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Web.Http;
    using System.Web.Http.Results;
    using NServiceBus;
    using OrganisationDomain.Integration.Messages.Messages;
    using OrganisationDomain.Integration.Messages.Messages.Expires;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using Services;

    [Authorize]
    [RoutePrefix("api/v1")]
    public class OrganisationApiController : ApiController
    {
        private readonly ILocalOrganisationRetriever _localOrganisationRetriever;

        private bool HasTimeoutOccurred { get; set; }

        public OrganisationApiController(ILocalOrganisationRetriever localOrganisationRetriever)
        {
            _localOrganisationRetriever = localOrganisationRetriever;
        }

        [HttpGet]
        [Route("organisations/ukprn/{ukprn}")]
        public IHttpActionResult GetOrganisationByUkPrn(int ukprn)
        {
            organisation org = _localOrganisationRetriever.GetOrganisationFromLocalDb(ukprn);
            if (org == null)
            {
               // create request, this message will expire in 30 seconds
               var request = new GetOrganisationRequest
               {
                   Ukprn = ukprn,
               };
                var response = GetOrganisation(request);

                if (HasTimeoutOccurred)
                    return new ResponseMessageResult(Request.CreateResponse(HttpStatusCode.GatewayTimeout, "The organisation service did not respond in a timely manner"));

                if (null != response)
                {
                    if (response.DuplicatesFound)
                    {
                        return BadRequest("Could not resolve duplicate UKPRNs for this provider");
                    }

                    if (response.OrganisationXmlIsInvalidAgainstSchema)
                    {
                        return InternalServerError(new Exception("An internal error with the organisation service has been identified and passed to support to investigate. Please contact support for more information."));
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

        [HttpGet]
        [Route("organisations/{organisationId}")]
        public IHttpActionResult GetOrganisationById(string organisationId)
        {
            //return new ResponseMessageResult(
            //    Request.CreateErrorResponse(
            //        HttpStatusCode.Gone,
            //        new HttpError("The FCT Organisation service has closed.")
            //    )
            //);

            // create request, this message will expire in 30 seconds
            var request = new GetOrganisationRequest { OrganisationId = organisationId };
            var response = GetOrganisation(request);

            if (HasTimeoutOccurred)
                return new ResponseMessageResult(Request.CreateResponse(HttpStatusCode.GatewayTimeout, "The organisation service did not respond in a timely manner"));

            if (null == response || null == response.Organisation)
            {
                return NotFound();
            }

            return Ok(response.Organisation);
        }

        [HttpGet]
        [Route("test")]
        public IHttpActionResult Test()
        {
            // this is currently called by the Dashboard to check that the service is up
            return Ok();
        }

        private GetOrganisationResponse GetOrganisation(GetOrganisationRequest request)
        {

            GetOrganisationResponse response = null;
            HasTimeoutOccurred = false;
            // send request to service bus and wait for a response
            var asyncResult = ServiceBus.Bus.Send(request)
                .Register(
                    ar =>
                    {
                        var completionResult = (CompletionResult)ar.AsyncState;
                        response = (GetOrganisationResponse)completionResult.Messages[0];
                    },
                    null);

            // wait for a response
            if (false == asyncResult.AsyncWaitHandle.WaitOne(TimeSpan.FromSeconds(double.Parse(ConfigurationManager.AppSettings["GetOrgAsyncWaitTimeInSeconds"]))))
            {
                // no response in 30 seconds - return not found
                HasTimeoutOccurred = true;
                return null;
            }
            else
            {
                return response;
            }
        }
    }
}