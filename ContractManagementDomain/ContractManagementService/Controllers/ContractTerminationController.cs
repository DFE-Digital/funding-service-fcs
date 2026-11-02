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
    public class ContractTerminationController : ControllerBase
    {
        private readonly ILogger _logger;

        public ContractTerminationController(ILogger logger)
        {
            _logger = logger;
        }

        [Route("contractmanagement/contractissueandreturn/updatecontractterminationdetails")]
        [HttpPost]
        public ActionResult UpdateContractTerminationDetails(UpdateContractTerminationDetailsCommand command)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.UpdateContractTerminationDetailsReceived,
                $"Update Contract Termination Details received for contract {command}");

            if (!command.GetContractIdentifier().IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.UpdateContractTerminationDetailsBadRequest,
                    "Update Contract Termination Details request had invalid parameters");

                return BadRequest();
            }

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("ContractManagement.ContractTermination"), command);

            _logger.LogInformation(ContractManagementLoggingEvents.UpdateContractTerminationDetailsAccepted,
                $"UpdateContractTerminationDetailsCommand sent and request accepted for contract {command}"); 

            return Accepted();
        }
        
        [Route("contractmanagement/contractissueandreturn/approveterminationinitiation")]
        [HttpPost]
        public ActionResult ApproveContractTerminationInitiation(ApproveContractTerminationInitiationCommand command)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.ApproveContractTerminationInitiationReceived, 
                $"Approve Initiation of Contract Termination received for contract {command}");

            if (!command.GetContractIdentifier().IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.ApproveContractTerminationInitiationBadRequest, 
                    "Approve Initiation of Contract Termination request had invalid parameters");

                return BadRequest();
            }

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("ContractManagement.ContractTermination"), command);

            _logger.LogInformation(ContractManagementLoggingEvents.ApproveContractTerminationInitiationAccepted, 
                $"ApproveContractTerminationInitiationCommand sent and request accepted for contract {command}");

            return Accepted();
        }

        [Route("contractmanagement/contractissueandreturn/cancelcontracttermination")]
        [HttpPost]
        public ActionResult CancelContractTermination([FromBody] ContractIdentifier contractIdentifier) 
        {
            _logger.LogInformation(ContractManagementLoggingEvents.CancelContractTerminationReceived, 
                $"Cancel Contract Termination received for contract {contractIdentifier}");

            if (!contractIdentifier.IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.CancelContractTerminationBadRequest, 
                    "Cancel Contract Termination request had invalid parameters");

                return BadRequest();
            }

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("ContractManagement.ContractTermination"), new CancelContractTerminationCommand()
            {
                ContractNumber = contractIdentifier.ContractNumber,
                VersionNumber = contractIdentifier.VersionNumber,
                SubVersionNumber = contractIdentifier.SubVersionNumber
            });

            _logger.LogInformation(ContractManagementLoggingEvents.CancelContractTerminationAccepted,
                $"CancelContractTerminationCommand sent and request accepted for contract {contractIdentifier}");

            return Accepted();
        }

        [Route("contractmanagement/contractissueandreturn/terminatecontract")]
        [HttpPost]
        public ActionResult TerminateContract(ContractIdentifier contractIdentifier)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.TerminateContractReceived, $"Terminate Contract received for contract {contractIdentifier}");

            if (!contractIdentifier.IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.TerminateContractBadRequest, "Terminate Contract request had invalid parameters");
                return BadRequest();
            }

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("ContractManagement.ContractTermination"), new TerminateContractCommand()
            {
                ContractNumber = contractIdentifier.ContractNumber,
                VersionNumber = contractIdentifier.VersionNumber,
                SubVersionNumber = contractIdentifier.SubVersionNumber
            });

            _logger.LogInformation(ContractManagementLoggingEvents.TerminateContractAccepted, 
                $"TerminateContractCommand sent and request accepted for contract {contractIdentifier}");

            return Accepted();
        }
    }
}