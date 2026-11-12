namespace ContractManagementDomain.Endpoint.InitiateContractWithdrawal
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractWithdrawal;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Contract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType;

    public class InitiateContractWithdrawalHandler : IHandleMessages<InitiateContractWithdrawalCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IXrmManager _xrmManager;
        private readonly IContractsManager _contractsManager;
        private readonly IDateProvider _dateProvider;

        public InitiateContractWithdrawalHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IXrmManager xrmManager,
            IContractsManager contractsManager,
            IDateProvider dateProvider)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _xrmManager = xrmManager;
            _contractsManager = contractsManager;
            _dateProvider = dateProvider;
        }

        public async Task Handle(InitiateContractWithdrawalCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
            ContractManagementLoggingEvents.InitiateContractWithdrawCommandReceived,
            $"{nameof(InitiateContractWithdrawalCommand)} received for MasterContractNumber:[{message.MasterContractNumber}] ContractNumber:[{message.ContractNumber}] ContractVersionNumber:[{message.ContractVersionNumber}] RequestSource:[{message.RequestSource}] ContractWithdrawalType:[{message.ContractWithdrawalType}]");

            await InitiateWithdrawal(
                message.MasterContractNumber,
                message.ContractNumber,
                message.ContractVersionNumber,
                message.ContractWithdrawalType,
                message.IncrementContractVersionNumber,
                message.ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment,
                message.Ukprn,
                message.ShouldMergeAmendmentTemplate,
                message.OverrideAmendmentTemplate,
                message.OverrideTemplateName,
                context)
                .ConfigureAwait(false);
        }

        private async Task InitiateWithdrawal(
            string masterContractNumber,
            string contractNumber,
            int versionNumber,
            ContractWithdrawalType withdrawalType,
            bool incrementContractVersionNumber,
            bool shouldAddPayableNonLevyAllocationOnPostWithdrawalAmendment,
            string ukprn,
            bool shouldMergeAmendmentTemplate,
            string overrideAmendmentTemplate,
            string overrideTemplateName,
            IMessageHandlerContext context)
        {
            try
            {
                RaiseExceptionOnError(!ValidateMessageParameters(masterContractNumber, contractNumber, versionNumber, out string errorMessage), errorMessage);

                Contract masterContract = _contractsManager.GetCorporateContractForSpecificVersion(contractNumber, masterContractNumber, versionNumber);

                RaiseExceptionOnError(!ContractValidator.ValidateMasterAndChildContracts(masterContract, out errorMessage), errorMessage);

                contractType contractToUpdate = masterContract.contracts.First();

                contractStatusTypeParentStatus contractStatus =
                    (contractStatusTypeParentStatus)
                        Enum.Parse(typeof(contractStatusTypeParentStatus), contractToUpdate.contractStatus.parentStatus);

                RaiseExceptionOnError(!ValidateContractStatus(contractStatus, contractToUpdate.contractStatus.status), $"Contract is not in right state => ContractStatus: {contractStatus}, ContractSubStatus: {contractToUpdate.contractStatus.status}");

                ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

                // Get the date, can be overridden with Contract Number as the key
                DateTime withdrawnDate = _dateProvider.GetDate(connectionInfo);

                // Set parent status to Withdrawn
                // Using v10 corporate schema, the name qualifier is useful to know
                contractToUpdate.contractStatus.parentStatus = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractStatusTypeParentStatus
                    .Withdrawn.ToString();

                contractToUpdate.StatusLastUpdatedDate = withdrawnDate;

                // Set Withdrawal sub-status and update CRM
                switch (withdrawalType)
                {
                    case ContractWithdrawalType.Agency:
                        contractToUpdate.contractStatus.status =
                            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractStatusTypeStatus
                                .WithdrawnByAgency.ToString();

                        _xrmManager.UpdateContractForWithdrawalSuccessful(contractToUpdate);
                        break;
                    case ContractWithdrawalType.OnBehalfOfProvider:
                        contractToUpdate.contractStatus.status =
                            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractStatusTypeStatus
                                .WithdrawnByProvider.ToString();

                        _xrmManager.UpdateContractForWithdrawalByProviderSuccessful(contractToUpdate);
                        break;
                    case ContractWithdrawalType.AutoWithdrawal:
                        contractToUpdate.contractStatus.status =
                            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractStatusTypeStatus
                                .AutoWithdrawn.ToString();

                        _xrmManager.UpdateContractForAutoWithdrawalSuccessful(contractToUpdate);
                        break;
                    case ContractWithdrawalType.BulkWithdrawalByAgency:
                        contractToUpdate.contractStatus.status = contractStatusTypeStatus.WithdrawnByAgency.ToString();
                        _xrmManager.UpdateContractForBulkWithdrawalByAgencySuccessful(contractToUpdate);
                        break;
                    default:
                        throw new NotSupportedException("Supported withdrawal types are Agency, OnBehalfOfProvider and AutoWithdrawal");
                }

                _logger.LogInformation(ContractManagementLoggingEvents.InitiateContractWithdrawHandlerUpdateContractForWithdrawal,
                    $"Contract was updated in CRM for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] VersionNumber:[{versionNumber}] ContractWithdrawalType:[{withdrawalType}]");

                await context.Publish(new ContractWithdrawnEvent
                {
                    CorporateContract = masterContract,
                    ContractWithdrawalType = withdrawalType,
                    IncrementContractVersionNumber = incrementContractVersionNumber,
                    Ukprn = ukprn,
                    ShouldAddPayableNonLevyAllocationToPostWithdrawalAmendment = shouldAddPayableNonLevyAllocationOnPostWithdrawalAmendment,
                    ShouldMergeAmendmentTemplate = shouldMergeAmendmentTemplate,
                    OverrideAmendmentTemplate = overrideAmendmentTemplate,
                    OverrideTemplateName = overrideTemplateName,
                }).ConfigureAwait(false);

            }
            catch (ContractValidationException contractValidationException)
            {
                _logger.LogError(
                    ContractManagementLoggingEvents.InitiateContractWithdrawHandlerDidNotUpdateContractForWithdrawal,
                    contractValidationException, $"{nameof(InitiateWithdrawal)} failed. Validation failed for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] ");
            }
            catch (NotSupportedException notSupportedException)
            {
                _logger.LogError(
                    ContractManagementLoggingEvents.InitiateContractWithdrawHandlerDidNotUpdateContractForWithdrawal,
                    notSupportedException, $"{nameof(InitiateWithdrawal)} failed for MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}] ");
            }
            catch (Exception e)
            {
                _logger.LogError(
                    ContractManagementLoggingEvents
                        .InitiateContractWithdrawHandlerDidNotUpdateContractForWithdrawal, e,
                    $"{nameof(InitiateWithdrawal)} failed: MasterContractNumber:[{masterContractNumber}] ContractNumber:[{contractNumber}]");

                throw;
            }
        }

        private static bool ValidateContractStatus(contractStatusTypeParentStatus contractStatus, string contractSubStatus)
        {
            return contractStatus == contractStatusTypeParentStatus.Draft &&
                   (contractSubStatus.Equals("Published to Provider", StringComparison.OrdinalIgnoreCase) ||
                    contractSubStatus.Equals("Withdrawal In Progress", StringComparison.OrdinalIgnoreCase));
        }

        private static bool ValidateMessageParameters(string masterContractNumber, string contractNumber, int versionNumber, out string errorMessage)
        {
            errorMessage = string.Empty;
            if (!ContractValidator.ValidateMasterAndChildContractNumber(masterContractNumber, contractNumber, out errorMessage))
            {
                return false;
            }

            if (versionNumber <= 0)
            {
                errorMessage = $"Version number {versionNumber} is invalid";
                return false;
            }

            return true;
        }

        private static void RaiseExceptionOnError(bool error, string errorMessage)
        {
            if (error)
            {
                throw new ContractValidationException(errorMessage);
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
