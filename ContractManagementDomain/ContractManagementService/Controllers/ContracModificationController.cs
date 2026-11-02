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
    public class ContracModificationController : ControllerBase
    {
        private readonly ILogger _logger;

        public ContracModificationController(ILogger logger)
        {
            _logger = logger;
        }

        [Route("contractmanagement/contractissueandreturn/approvemodification")]
        [HttpPost]
        public ActionResult ApproveContractModification(ApproveContractModificationCommand command)
        {
            var result = ProcessHttpRequest(command);
            return result;
        }

        [Route("contractmanagement/contractissueandreturn/updatemodification")]
        [HttpPost]
        public ActionResult UpdateContractModification(UpdateContractModificationCommand command)
        {
            var result = ProcessHttpRequest(command);
            return result;
        }

        [Route("contractmanagement/contractissueandreturn/cancelmodification")]
        [HttpPost]
        public ActionResult CancelContractModification(CancelContractModificationCommand command)
        {
            var result = ProcessHttpRequest(command);
            return result;
        }

        private ActionResult ProcessHttpRequest<T>(T command) where T : ContractInformationBaseCommand
        {
            _logger.LogInformation(ContractManagementLoggingEvents.ContractModificationHttpRequestReceived,
                $"{command.GetType().Name} HTTP request received: {command}");

            if (!command.GetContractIdentifier().IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.ContractModificationBadHttpRequest,
                    $"{command.GetType().Name} HTTP request has invalid parameters: {command}");

                return new BadRequestResult();
            }

            ServiceBus.Bus.Send("ContractManagement.ContractTermination", command);

            _logger.LogInformation(ContractManagementLoggingEvents.ContractModificationHttpRequestProcessed,
                $"{command.GetType().Name} HTTP request processed successfully: {command}");

            return new AcceptedResult();
        }
    }
}