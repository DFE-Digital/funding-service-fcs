namespace SFA.FCT.ContractManagementService.Controllers
{
    using Common;
    using Common.Commands;
    using CrossDomain.Integration.Common;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using NSB;

    [ApiController]
    [Authorize]
    public class ContractClosureController : ControllerBase
    {
        private readonly ILogger _logger;

        public ContractClosureController(ILogger logger)
        {
            _logger = logger;
        }

        [Route("contractmanagement/contractissueandreturn/initiatecontractclosure")]
        [HttpPost]
        public ActionResult InitiateContractClosure([FromBody] ContractIdentifier closeContractInformation)
        {
            return SendInitiateContractClosureCommand(closeContractInformation);
        }

        [Route("contractmanagement/contractissueandreturn/approvecontractclosure")]
        [HttpPost]
        public ActionResult ApproveContractClosure([FromBody] ContractIdentifier closeContractInformation)
        {
            return SendApproveContractClosureCommand(closeContractInformation);
        }

        private ActionResult SendApproveContractClosureCommand(ContractIdentifier closeContractInformation)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.ApproveContractClosureRequestReceived, $"Approve contract closure received for contract {closeContractInformation}");
            if (!closeContractInformation.IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.ApproveContractClosureBadRequest, "Request had invalid parameters");
                return new BadRequestResult();
            }

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("ContractManagementDomain.ContractClosure"), new ApproveContractClosureCommand()
            {
                ContractNumber = closeContractInformation.ContractNumber,
                VersionNumber = closeContractInformation.VersionNumber,
                SubVersionNumber = closeContractInformation.SubVersionNumber
            });

            _logger.LogInformation(ContractManagementLoggingEvents.ApproveContractClosureRequestAccepted, $"{nameof(ApproveContractClosureCommand)} sent and request accepted for contract {closeContractInformation}");

            return new AcceptedResult();
        }

        private ActionResult SendInitiateContractClosureCommand(ContractIdentifier closeContractInformation)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.ContractClosureRequestReceived, $"Initiate Contract Closure received for contract {closeContractInformation}");

            if (!closeContractInformation.IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.ContractClosureBadRequest, "Request had invalid parameters");
                return new BadRequestResult();
            }

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("ContractManagementDomain.ContractClosure"), new InitiateContractClosureCommand
            {
                ContractNumber = closeContractInformation.ContractNumber,
                VersionNumber = closeContractInformation.VersionNumber,
                SubVersionNumber = closeContractInformation.SubVersionNumber
            });

            _logger.LogInformation(ContractManagementLoggingEvents.ContractClosureRequestAccepted, $"{nameof(InitiateContractClosureCommand)} sent and request accepted for contract {closeContractInformation}");

            return new AcceptedResult();
        }
    }
}