namespace Operations.Web.Controllers
{
    using System.Threading.Tasks;
    using System.Web.Http;
    using Filters;
    using Dtos;
    using Repositories;
    using Services;
    using Infrastructure;
    using System;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Linq;
    using System.Security.Claims;

    [RoutePrefix("dasevents")]
    public class DasEventsController : ApiController
    {
        private readonly IOrganisationRepository _organisationRepository;
        private readonly IDasRequestService _dasRequestService;
        private readonly ITransportMessageSender _messageSender;
        private readonly IEngagementEventRepository _engagementEventRepository;
        private readonly ILogger _logger;

        public DasEventsController(IOrganisationRepository organisationRepository, IDasRequestService dasRequestService, ITransportMessageSender messageSender, IEngagementEventRepository engagementEventRepository, ILogger logger)
        {
            _organisationRepository = organisationRepository;
            _dasRequestService = dasRequestService;
            _messageSender = messageSender;
            _engagementEventRepository = engagementEventRepository;
            _logger = logger;
        }

        [HttpPost, Route("initiatepublication"), AuthorizeFcsUserGroup]
        public async Task<IHttpActionResult> InitiatePublication(OrganisationInfo organisationInfo)
        {
            _logger.LogInformation(LogInformation.InitiateDasEventPublication, $"DasEventsController: InitiatePublication - ukprn: {organisationInfo.Ukprn}, user: {User.Identity.Name}");

            var orgInfoInDb = await _organisationRepository.GetOrganisationInfo(organisationInfo.Ukprn).ConfigureAwait(false);

            Func<OrganisationInfo, Task<IHttpActionResult>> sendNewDasRequest = async o =>
            {
                await InsertAndSendNewDasContractRequestCommand(ukprn:o.Ukprn);

                return Created("", Guid.Empty);
            };

            return await orgInfoInDb.MatchAsync(Some: sendNewDasRequest, None: () => BadRequest());
        }

        [HttpGet, Route("recent")]
        public async Task<IHttpActionResult> GetRecentEngagementEvents()
        {
            var recentEngagementEvents = await _engagementEventRepository.GetRecentEngagementEvents()
                .ConfigureAwait(false);

            return Ok(recentEngagementEvents);
        }

        [HttpGet, Route("is-authorized")]
        public async Task<IHttpActionResult> IsAuthorizedToInitiatePublication()
        {
            var user = RequestContext.Principal as ClaimsPrincipal;
            var groupStringValue = System.Configuration.ConfigurationManager.AppSettings["FcsUserGroup"];

            var groupClaims = user.FindAll("groups").ToList();

            _logger.LogInformation(1, $"DasEventsController: IsAuthorizedToInitiatePublication - user: {user.Identity.Name}, groupStringValue: {groupStringValue}");
            _logger.LogInformation(1, $"DasEventsController: IsAuthorizedToInitiatePublication - Iterating ClaimsPrincipal.Current groups. Count: {groupClaims.ToList().Count}");

            await Task.Delay(1);
            var sequence = 1;
            foreach (var claim in ClaimsPrincipal.Current.FindAll("groups"))
            {
                _logger.LogInformation(1, $"DasEventsController: IsAuthorizedToInitiatePublication - {sequence} ClaimsPrincipal Value : {claim.Value}");
                _logger.LogInformation(1, $"DasEventsController: IsAuthorizedToInitiatePublication - {sequence} ClaimsPrincipal Issuer : {claim.Issuer}");
                _logger.LogInformation(1, $"DasEventsController: IsAuthorizedToInitiatePublication - {sequence} ClaimsPrincipal OriginalIssuer : {claim.OriginalIssuer}");
                _logger.LogInformation(1, $"DasEventsController: IsAuthorizedToInitiatePublication - {sequence} ClaimsPrincipal Subject : {claim.Subject}");
                _logger.LogInformation(1, $"DasEventsController: IsAuthorizedToInitiatePublication - {sequence} ClaimsPrincipal Type : {claim.Type}");
                _logger.LogInformation(1, $"DasEventsController: IsAuthorizedToInitiatePublication - {sequence} ClaimsPrincipal ValueType : {claim.ValueType}");
                sequence++;
            }

            return Ok(groupClaims.Any(claim => claim.Value == groupStringValue));
        }

        private async Task InsertAndSendNewDasContractRequestCommand(string ukprn)
        {
            var result = await _engagementEventRepository.AddIfNotAlreadyAdded(ukprn);
            if (result.IsAdded)
            {
                var dasRequest = await _dasRequestService.SetupDasRequest(ukprn, result.EventId).ConfigureAwait(false);

                var newDasContractRequestCommand = new NewDasContractRequestCommand { DasRequest = dasRequest, DasEngagementEventId = dasRequest.DasEngagementEventId };

                await _messageSender.Send(command: newDasContractRequestCommand, destination: "ContractRequestDomain.BulkUpload");
                _logger.LogInformation(LogInformation.InitiateDasEventMessageSent, $"Sent NewDasContractRequestCommand - ukprn: {ukprn}, uesr: {User.Identity.Name}");
            }
        }
    }
}