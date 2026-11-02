namespace SFA.FCT.ContractManagementService.Controllers
{
    using Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using NSB;

    [ApiController]
    [Authorize]
    [Route(RoutePrefix)]
    public class FundingClaimReconciliationCommandController : ControllerBase
    {
        private readonly ILogger _logger;

        public FundingClaimReconciliationCommandController(ILogger logger)
        {
            _logger = logger;
        }

        public const string RoutePrefix = "api/performance-management/funding-claim-reconciliations";

        [HttpPost]
        [Route("recalc")]
        public ActionResult ReCalculate(InitiateReCalculationForFcrCommand initiateReCalculationForFcrCommand)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.InitiateReCalculationForFcrCommandReceived, $"Received a POST call to initiate re-calculation for {initiateReCalculationForFcrCommand}");

            ServiceBus.Bus.Send(
                FctEndpoint.GenerateEndpointName("PerformanceManagementDomain.RecalculationInitiated"),
                initiateReCalculationForFcrCommand);

            _logger.LogInformation(ContractManagementLoggingEvents.InitiateReCalculationForFcrCommandProcessed, $"Sent a InitiateReCalculationForFcrCommand {initiateReCalculationForFcrCommand}");

            return Accepted();
        }
    }
}