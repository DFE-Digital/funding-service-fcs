namespace ContractManagementDomain.Endpoint.ContractClosure.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Repositories;
    using Repositories;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public class ValidationService : IValidationService
    {
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly IApprovedContractRepository _approvedContractRepository;
        private readonly IDateProvider _dateProvider;
        private readonly IMonthEndHistoryRepository _monthEndHistoryRepository;
        private readonly IReadOnlyCollection<MethodWithErrorMessage> _validationRulesForInitiateClosure;
        private readonly IReadOnlyCollection<MethodWithErrorMessage> _validationRulesForApproveClosure;

        private const string OutstandingPaymentsExistErrorMessage = "outstanding payments exist";

        public ValidationService(
            ICrmContractRepository crmContractRepository,
            IDateProvider dateProvider,
            IApprovedContractRepository approvedContractRepository,
            IMonthEndHistoryRepository monthEndHistoryRepository)
        {
            _crmContractRepository = crmContractRepository;
            _dateProvider = dateProvider;
            _approvedContractRepository = approvedContractRepository;
            _monthEndHistoryRepository = monthEndHistoryRepository;
            _validationRulesForInitiateClosure = new List<MethodWithErrorMessage>
            {
               new MethodWithErrorMessage(IsContractEndDateInThePastIfPresent, "its end date must be in the past"),
               new MethodWithErrorMessage(IsContractLatestVersion, "an outstanding draft amendment exists"),
               new MethodWithErrorMessage(ContractHasNoOutstandingPayments, OutstandingPaymentsExistErrorMessage)
            };
            _validationRulesForApproveClosure = new List<MethodWithErrorMessage>
            {
                new MethodWithErrorMessage(ContractHasNoOutstandingPayments, OutstandingPaymentsExistErrorMessage),
                new MethodWithErrorMessage(MonthEndNotInProgress, "month-end processing is in progress - please try again later")
            };
        }

        public string GetFirstFailureMessageForInitiateContractClosure(ContractIdentifier contractIdentity, ConnectionInfo connectionInfo)
        {
            return _validationRulesForInitiateClosure.FirstOrDefault(r => !r.RuleMethod(contractIdentity, connectionInfo))?.Message;
        }

        public string GetFirstFailureMessageForApproveContractClosure(ContractIdentifier contractIdentity, ConnectionInfo connectionInfo)
        {
            return _validationRulesForApproveClosure.FirstOrDefault(r => !r.RuleMethod(contractIdentity, connectionInfo))?.Message;
        }

        private bool IsContractEndDateInThePastIfPresent(ContractIdentifier contractIdentity, ConnectionInfo connectionInfo)
        {
            DateTime currentDate = _dateProvider.GetDate(connectionInfo);

            ContractEndDateInfo contractEndDateInfo = _crmContractRepository.GetContractEndDateInfoByContractNumberVersionAndSubVersion(
                contractNumber: contractIdentity.ContractNumber,
                version: contractIdentity.VersionNumber,
                subVersion: contractIdentity.SubVersionNumber);

            if (contractEndDateInfo.IsContractPresent)
            {
                return (contractEndDateInfo.EndDate ?? currentDate.AddDays(-1)) < currentDate;
            }

            throw new InvalidOperationException($"Contract not found in Crm - {contractIdentity}");
        }

        private bool IsContractLatestVersion(ContractIdentifier contractIdentity, ConnectionInfo connectionInfo)
        {
            return _crmContractRepository.IsContractLatestVersion(
                contractIdentity.ContractNumber,
                contractIdentity.VersionNumber,
                contractIdentity.SubVersionNumber);
        }

        private bool MonthEndNotInProgress(ContractIdentifier contractIdentity, ConnectionInfo connectionInfo)
        {
            return !_monthEndHistoryRepository.IsMonthEndInProgress(connectionInfo);
        }

        private bool ContractHasNoOutstandingPayments(ContractIdentifier contractIdentity, ConnectionInfo connectionInfo)
        {
            return !_approvedContractRepository.HasOutstandingPayments(contractIdentity.ContractNumber, contractIdentity.VersionNumber, contractIdentity.SubVersionNumber, connectionInfo);
        }

        private class MethodWithErrorMessage
        {
            public MethodWithErrorMessage(Func<ContractIdentifier, ConnectionInfo, bool> ruleMethod, string message)
            {
                RuleMethod = ruleMethod;
                Message = message;
            }

            public Func<ContractIdentifier, ConnectionInfo, bool> RuleMethod { get; }

            public string Message { get; }
        }
    }
}
