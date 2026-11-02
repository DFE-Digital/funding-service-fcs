namespace SFA.FCT.ContractManagementService.Controllers
{
    using System.Threading.Tasks;
    using Castle.Core.Internal;
    using Common;
    using Common.Commands;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.ContractWithdrawal;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using NSB;

    [ApiController]
    [Authorize]
    public class ContractManagementController : ControllerBase
    {
        private readonly ILogger _logger;
        public ContractManagementController(ILogger logger)
        {
            _logger = logger;
        }

        #region Approval

        [Route("contractmanagement/contractissueandreturn/confirmreceiptofdigitalsignature")]
        [HttpPost]
        public ActionResult InitiateApprovalByExternalSystem(ContractInformation contractInformation)
        {
            return SendInitiateContractAppovalCommand(contractInformation, ApprovalRequestSource.External);
        }

        [Route("contractmanagement/contractissueandreturn/confirmreceiptofsignedcontract")]
        [HttpPost]
        public ActionResult InitiateApprovalInternally(ContractInformation contractInformation)
        {
            return SendInitiateContractAppovalCommand(contractInformation, ApprovalRequestSource.Fcs);
        }

        private ActionResult SendInitiateContractAppovalCommand(ContractInformation contractInformation, ApprovalRequestSource requestSource)
        {
            if (!contractInformation.IsValid())
            {
                _logger.LogInformation(ContractManagementLoggingEvents.InitiateContractApprovalBadRequest, "Initiate Contract Approval received Bad request");
                return BadRequest("The contract and master number must be set and the version number must be non zero");
            }

            _logger.LogInformation(ContractManagementLoggingEvents.InitiateContractApprovalReceived, $"Initiate Contract Approval received for contract {contractInformation.ContractNumber} and master contract {contractInformation.MasterContractNumber} requested by client - {requestSource}");

            ServiceBus.Bus.Send(
                    FctEndpoint.GenerateEndpointName("ContractManagementDomain.InitiateContractApproval"),
                    new InitiateContractApprovalCommand() {
                        ContractNumber = contractInformation.ContractNumber,
                        MasterContractNumber = contractInformation.MasterContractNumber,
                        ContractVersionNumber = contractInformation.ContractVersionNumber.Value,
                        RequestSource = requestSource
                    });

            _logger.LogInformation(ContractManagementLoggingEvents.InitiateContractApprovalCommandSent, $"{nameof(InitiateContractApprovalCommand)} sent for {contractInformation.ContractNumber} requested by client - {requestSource}");
            
            return new AcceptedResult();
        }

        #endregion

        #region Withdrawal

        [Route("contractmanagement/contractissueandreturn/withdrawcontract")]
        [HttpPost]
        public ActionResult WithdrawContract(ContractInformation contractInformation) => SendWithdrawContractCommand(contractInformation, WithdrawalRequestSource.Fcs, ContractWithdrawalType.Agency);

        [Route("contractmanagement/contractissueandreturn/withdrawonbehalfofprovider")]
        [HttpPost]
        public ActionResult WithdrawContractOnBehalfOfProvider(ContractInformation contractInformation) => SendWithdrawContractCommand(contractInformation, WithdrawalRequestSource.Fcs, ContractWithdrawalType.OnBehalfOfProvider);

        [Route("contractmanagement/contractissueandreturn/autowithdrawcontract")]
        [HttpPost]
        public ActionResult AutoWithdrawContract(ContractInformation contractInformation) => SendWithdrawContractCommand(contractInformation, WithdrawalRequestSource.External, ContractWithdrawalType.AutoWithdrawal);

        private ActionResult SendWithdrawContractCommand(ContractInformation contractInformation, WithdrawalRequestSource requestSource, ContractWithdrawalType withdrawalType)
        {
            if (
                    contractInformation == null || 
                    contractInformation.MasterContractNumber.IsNullOrEmpty() || 
                    contractInformation.ContractNumber.IsNullOrEmpty() ||
                    contractInformation.ContractVersionNumber == null ||
                    contractInformation.ContractVersionNumber <= 0
               )
            {
                _logger.LogInformation(ContractManagementLoggingEvents.WithdrawContractBadContractDetails, $"Missing master contract or contract number for withdraw contract request. RequestSource[{requestSource}], WithdrawalType[{withdrawalType}]");

                return new BadRequestResult();
            }

            _logger.LogInformation(ContractManagementLoggingEvents.WithdrawRequestReceived, $"Withdraw contract request received. MasterContractNumber[{contractInformation.ContractNumber}], ContractNumber[{contractInformation.MasterContractNumber}], VersionNumber[{contractInformation.ContractVersionNumber ?? 0}], RequestSource[{requestSource}], WithdrawalType[{withdrawalType}]");

            ServiceBus.Bus.Send(
                    FctEndpoint.GenerateEndpointName("ContractManagementDomain.InitiateContractWithdrawal"),
                    new InitiateContractWithdrawalCommand
                    {
                        ContractNumber = contractInformation.ContractNumber,
                        MasterContractNumber = contractInformation.MasterContractNumber,
                        ContractVersionNumber = contractInformation.ContractVersionNumber.Value,
                        RequestSource = requestSource,
                        ContractWithdrawalType = withdrawalType
                    });

            _logger.LogInformation(ContractManagementLoggingEvents.WithdrawRequestAccepted, $"{nameof(InitiateContractWithdrawalCommand)} sent and request accepted. MasterContractNumber[{contractInformation.ContractNumber}], ContractNumber[{contractInformation.MasterContractNumber}], VersionNumber[{contractInformation.ContractVersionNumber ?? 0}], RequestSource[{requestSource}], WithdrawalType[{withdrawalType}]");

            return new AcceptedResult();
        }

        #endregion

        #region Confirm Publication to Provider

        [Route("contractmanagement/contractissueandreturn/confirmpublicationtoprovider")]
        [HttpPost]
        public ActionResult ConfirmPublicationToProvider(ContractInformation contractInformation) => SendConfirmPublicationToProviderCommand(contractInformation.ContractNumber, contractInformation.MasterContractNumber);

        private ActionResult SendConfirmPublicationToProviderCommand(string contractNumber, string masterContractNumber)
        {
            if (string.IsNullOrEmpty(contractNumber) || string.IsNullOrEmpty(masterContractNumber))
            {
                _logger.LogError(ContractManagementLoggingEvents.ConfirmPublicationToProviderBadContractNumber,
                    "Empty contract or master contract received");
                return BadRequest();
            }

            ServiceBus.Bus.Send<ConfirmPublicationToProviderCommand>(
                FctEndpoint.GenerateEndpointName("ContractManagementDomain.ConfirmPublicationToProvider"),
                c =>
                {
                    c.ContractNumber = contractNumber;
                    c.MasterContractNumber = masterContractNumber;
                });

            _logger.LogInformation(ContractManagementLoggingEvents.ConfirmPublicationToProviderCommandSent,
                $"{nameof(ConfirmPublicationToProviderCommand)} sent for {contractNumber}");

            return new AcceptedResult();
        }

        #endregion

        #region Release for Review

        [Route("contractmanagement/contractissueandreturn/releaseforreview")]
        [HttpPost]
        public ActionResult ReleaseForReview(ContractInformation contractInformation) => SendReleaseForReviewCommand(contractInformation.ContractNumber, contractInformation.MasterContractNumber);

        private ActionResult SendReleaseForReviewCommand(string contractNumber, string masterContractNumber)
        {
            if (string.IsNullOrEmpty(contractNumber) || string.IsNullOrEmpty(masterContractNumber))
            {
                _logger.LogError(ContractManagementLoggingEvents.ReleaseForReviewBadContractNumber, "Empty contract or master contract received");
                return BadRequest();
            }

            ServiceBus.Bus.Send<ReleaseForReviewCommand>(
                FctEndpoint.GenerateEndpointName("ContractManagementDomain.ReleaseForReview"),
                c =>
                {
                    c.ContractNumber = contractNumber;
                    c.MasterContractNumber = masterContractNumber;
                });

            _logger.LogInformation(ContractManagementLoggingEvents.ReleaseForReviewCommandSent, $"{nameof(ReleaseForReviewCommand)} sent for {contractNumber}");

            return new AcceptedResult();
        }

        #endregion

        #region Delete Draft

        [Route("contractmanagement/contractissueandreturn/deletedraftcontract")]
        [HttpDelete]
        public async Task<ActionResult> DeleteDraftContract(ContractInformation contractInformation)
        {
            if (string.IsNullOrEmpty(contractInformation?.ContractNumber) || contractInformation.ContractVersionNumber == null)
            {
                _logger.LogInformation(ContractManagementLoggingEvents.DeleteDraftContractBadRequest, "Delete Draft Contract received Bad request");
                return await Task.FromResult(new BadRequestResult());
            }

            _logger.LogInformation(ContractManagementLoggingEvents.DeleteDraftContractReceived, $"Delete Draft Contract received for contract {contractInformation.ContractNumber} v{contractInformation.ContractVersionNumber}");

            ServiceBus.Bus.Send(FctEndpoint.GenerateEndpointName("ContractManagement.DeleteContract"), 
                new DeleteDraftContractItemsCommand
                {
                    ContractNumber = contractInformation.ContractNumber,
                    VersionNumber = (int)contractInformation.ContractVersionNumber
                });

            _logger.LogInformation(ContractManagementLoggingEvents.DeleteDraftContractItemsCommandSent, $"DeleteDraftContractItemsCommand sent for {contractInformation.ContractNumber} v{contractInformation.ContractVersionNumber}");

            return await Task.FromResult(new AcceptedResult());
        }

        #endregion
    }
}
