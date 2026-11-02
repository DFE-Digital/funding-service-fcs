namespace SFA.FCT.ContractManagementService.Controllers
{
    using Common;
    using Common.Commands;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using NSB;

    [ApiController]
    [Authorize]
    public class ContractManagementCfsReleaseController : ControllerBase
    {
        private readonly ILogger _logger;

        public ContractManagementCfsReleaseController(ILogger logger)
        {
            _logger = logger;
        }

        [Route("contractmanagement/contractissueandreturn/cfs-release/allocations")]
        [HttpPost]
        public ActionResult InitiateApprovalByExternalSystem(InitiateCfsAllocationReleaseCommand command)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.InitiateCfsAllocationReleaseCommandReceived,
                $"InitiateCfsAllocationReleaseCommand received {command}");

            ServiceBus.Bus.Send(
               "ContractRequestDomain.Cfs.Release", command);

            _logger.LogInformation(ContractManagementLoggingEvents.InitiateCfsAllocationReleaseCommandProcessed,
                $"InitiateCfsAllocationReleaseCommand processed {command}");

            return new AcceptedResult();
        }
    }
}
