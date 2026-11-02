namespace SFA.FCT.ContractManagementService.Controllers
{
    using Common;
    using CrossDomain.Integration.Common;
    using Framework.Logging.Interfaces;
    using NSB;
    using CrossDomain.Integration.Messages.Commands;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;

    [ApiController]
    [Authorize]
    public class FundingConfirmationReportController : ControllerBase
    {
        private readonly ILogger _logger;

        public FundingConfirmationReportController(ILogger logger)
        {
            _logger = logger;
        }

        [Route("contractmanagement/funding-confirmation-report")]
        [HttpPost]
        public ActionResult CreateFundingConfirmationReport()
        {
            _logger.LogInformation(ContractManagementLoggingEvents.CreateFundingConfirmationReportReceived, $"Create Funding Confirmation Report received");

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("Operations.FundingConfirmationReport"), new CreateFundingConfirmationReportCommand("CFCR"));

            _logger.LogInformation(ContractManagementLoggingEvents.CreateFundingConfirmationReportCommandSent, $"CreateFundingConfirmationReportCommand sent");

            return Accepted();
        }

        [Route("contractmanagement/la-funding-confirmation-report")]
        [HttpPost]
        public ActionResult CreateLAFundingConfirmationReport()
        {
            _logger.LogInformation(ContractManagementLoggingEvents.CreateLAFundingConfirmationReportReceived, $"Create LA Funding Confirmation Report received");

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("Operations.FundingConfirmationReport"), new CreateFundingConfirmationReportCommand("LCFCR"));

            _logger.LogInformation(ContractManagementLoggingEvents.CreateFundingConfirmationReportCommandSent, $"CreateLAFundingConfirmationReportCommand sent");

            return Accepted();
        }

    }
}