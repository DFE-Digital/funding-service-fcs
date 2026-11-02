namespace SFA.FCT.ContractManagementService.Controllers
{
    using Common;
    using Common.Commands;
    using FCS.Worker.Common;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using NSB;

    [ApiController]
    [Authorize]
    public class ContractAmendmentController : ControllerBase
    {
        private readonly ILogger _logger;

        public ContractAmendmentController(ILogger logger)
        {
            _logger = logger;
        }

        [Route("contractmanagement/contractissueandreturn/amendcontract")]
        [HttpPost]
        public ActionResult AmendContract(ContractAmendmentInformation contractAmendmentInformation)
        {
            return SendAmendContractNonFinancialAmendmentCommand(contractAmendmentInformation);
        }

        private ActionResult SendAmendContractNonFinancialAmendmentCommand(ContractAmendmentInformation contractAmendmentInformation)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.AmendContractRequestReceived, $"Amend Contract received for contract {contractAmendmentInformation}");

            if (!contractAmendmentInformation.IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.AmendContractBadRequest, "Request had invalid parameters");
                return new BadRequestResult();
            }

            ServiceBus.Bus.Send("ContractCreateDomain.NonFinancialAmendment", new AmendContractNonFinancialAmendmentCommand
            {
                ContractNumber = contractAmendmentInformation.ContractNumber,
                VersionNumber = contractAmendmentInformation.VersionNumber,
                SubVersionNumber = contractAmendmentInformation.SubVersionNumber,
                AmendmentType = contractAmendmentInformation.GetAmendmentType(),
                IsNonFinancialAmendment = true
            });

            _logger.LogInformation(ContractManagementLoggingEvents.AmendContractRequestAccepted, $"AmendContractNonFinancialAmendmentCommand sent and request accepted for contract {contractAmendmentInformation}");

            return new AcceptedResult();
        }
    }
}
