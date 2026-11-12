namespace ContractManagementDomain.Endpoint.InitiateContractApproval
{
    using System;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Services;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using contractStatusTypeParentStatus = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractStatusTypeParentStatus;

    public abstract class InitiateContractApprovalBase
    {
        private readonly ILogger _logger;
        private readonly IMonthEndHistoryRepository _monthEndHistoryRepository;
        private readonly IFundingTypeFundingPeriodService _fundingTypeFundingPeriodService;
        private readonly IXrmManager _xrmManager;
        private readonly IContractsManager _contractManager;

        private const string ReasonForFailure = "There was a failure to approve contract for UKPRN: {0} & Contract: {1}. This failure was caused by contracting activity having closed for {2} {3} contracts.";

        protected InitiateContractApprovalBase(
            ILogger logger,
            IMonthEndHistoryRepository monthEndHistoryRepository,
            IFundingTypeFundingPeriodService fundingTypeFundingPeriodService,
            IXrmManager xrmManager,
            IContractsManager contractManager)
        {
            _logger = logger;
            _monthEndHistoryRepository = monthEndHistoryRepository;
            _fundingTypeFundingPeriodService = fundingTypeFundingPeriodService;
            _xrmManager = xrmManager;
            _contractManager = contractManager;
        }

        protected bool ShouldDefer(int contractVersionNumber, ConnectionInfo connectionInfo)
        {
            return IsAmendment(contractVersionNumber) && _monthEndHistoryRepository.IsMonthEndInProgress(connectionInfo);
        }

        protected static TimeSpan GetDeferralTimeSpan()
        {
            return TimeSpan.FromMinutes(int.Parse(ConfigurationManager.AppSettings["ContractManagement.DeferMinutes"]));
        }

        protected async Task InitiateApproval(string masterContractNumber, string contractNumber, int versionNumber, ApprovalRequestSource requestSource, ConnectionInfo connectionInfo, IMessageHandlerContext context)
        {
            try
            {
                var masterContract = GetValidatedMasterContract(masterContractNumber, contractNumber, versionNumber, out _);

                var contractToUpdate = masterContract.contracts.First();

                if (_fundingTypeFundingPeriodService.IsProcessDateAfterFundingTypeContractingActivityCloseDate(contractToUpdate.fundingType.fundingTypeCode, contractToUpdate.GetFundingPeriod(), connectionInfo))
                {
                    _logger.LogInformation(
                        ContractManagementLoggingEvents.InitiateContractApprovalHandlerDidNotUpdateContractForApproval,
                        $"InitiateContractApprovalCommand for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] ContractVersionNumber:[{versionNumber}] was not processed due to approval request received after contracting activity close date ");

                    if (requestSource == ApprovalRequestSource.Fcs)
                    {
                        _xrmManager.UpdateContractForManualFailure(contractToUpdate, string.Format(ReasonForFailure, contractToUpdate.contractor.ukprn, contractToUpdate.contractNumber, contractToUpdate.fundingType.fundingTypeName, contractToUpdate.period.period1));
                    }

                    return;
                }

                UpdateIfContractIsInRightState(requestSource, contractToUpdate);

                await context.Send(new PublishApprovedContractCommand
                {
                    ContractNumber = contractToUpdate.contractNumber,
                    MasterContractNumber = masterContract.contractNumber
                });

            }
            catch (ContractValidationException contractValidationException)
            {

                _logger.LogError(
                    ContractManagementLoggingEvents.InitiateContractApprovalHandlerDidNotUpdateContractForApproval,
                    contractValidationException, $"InitiateApproval failed. Validation failed for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] ");

            }
            catch (NotSupportedException notSupportedException)
            {

                _logger.LogError(
                    ContractManagementLoggingEvents.InitiateContractApprovalHandlerDidNotUpdateContractForApproval,
                    notSupportedException, $"UpdateIfContractIsInRightState failed. Updation failed for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] ");

            }
            catch (Exception e)
            {
                _logger.LogError(
                    ContractManagementLoggingEvents
                        .InitiateContractApprovalHandlerDidNotUpdateContractForApproval, e,
                    $"InitiateApproval failed: MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}]");

                throw;
            }
        }

        private Contract GetValidatedMasterContract(string masterContractNumber, string contractNumber, int versionNumber, out string errorMessage)
        {
            RaiseExceptionOnError(
                !ContractValidator.ValidateMasterAndChildContractNumber(masterContractNumber, contractNumber, out errorMessage),
                errorMessage);

            Contract masterContract = _contractManager.GetCorporateContractForSpecificVersion(contractNumber, masterContractNumber, versionNumber);

            RaiseExceptionOnError(!ContractValidator.ValidateMasterAndChildContracts(masterContract, out errorMessage),
                errorMessage);

            return masterContract;
        }

        private static void RaiseExceptionOnError(bool error, string errorMessage)
        {
            if (error)
            {
                throw new ContractValidationException(errorMessage);
            }
        }

        private void UpdateIfContractIsInRightState(ApprovalRequestSource requestSource, contractType contractToUpdate)
        {
            var contractParentStatus =
                   (contractStatusTypeParentStatus)
                       Enum.Parse(typeof(contractStatusTypeParentStatus), contractToUpdate.contractStatus.parentStatus);

            if (IsContractInCorrectState(contractParentStatus, contractToUpdate.contractStatus.status))
            {
                UpdateContractDependingOnRequestSource(requestSource, contractToUpdate);
            }
            else
            {
                _logger.LogError(ContractManagementLoggingEvents.InitiateContractApprovalHandlerContractInWrongStateError, $"Contract is not in right state => ContractStatus: {contractParentStatus}, ContractSubStatus: {contractToUpdate.contractStatus.status}");
            }
        }

        private static bool IsAmendment(int contractVersionNumber)
        {
            return contractVersionNumber > 1;
        }

        private static bool IsContractInCorrectState(contractStatusTypeParentStatus contractStatus, string contractSubStatus)
        {
            return (contractStatus == contractStatusTypeParentStatus.Draft &&
                    (contractSubStatus.Equals("Published to Provider", StringComparison.OrdinalIgnoreCase) ||
                     contractSubStatus.Equals("Approval In Progress", StringComparison.OrdinalIgnoreCase)));
        }

        private void UpdateContractDependingOnRequestSource(ApprovalRequestSource requestSource, contractType contractToUpdate)
        {
            _logger.LogInformation(
                    ContractManagementLoggingEvents.InitiateContractApprovalHandlerUpdateContractForApproval,
                    $"Initiating approval... MasterContractNumber:[{contractToUpdate.parentContractNumber}] ContractNumber:[{contractToUpdate.contractNumber}] ContractVersionNumber:[{contractToUpdate.contractVersionNumber}] RequestSource:[{requestSource}]");

            switch (requestSource)
            {
                case ApprovalRequestSource.Auto:
                    _xrmManager.UpdateContractForNotificationApproval(contractToUpdate);

                    break;
                case ApprovalRequestSource.External:
                    _xrmManager.UpdateContractForElectronicApproval(contractToUpdate);

                    break;
                case ApprovalRequestSource.Fcs:
                    _xrmManager.UpdateContractForManualApproval(contractToUpdate);

                    break;
                default:
                    throw new NotSupportedException(
                        $"ApprovalRequestSource not supported. Contracts are approved via ApprovalRequestSource.Auto, ApprovalRequestSource.External or ApprovalRequestSource.Fcs");
            }
        }


        private class ContractValidationException : Exception
        {
            public ContractValidationException(string message)
                : base(message)
            {
            }
        }
    }
}
