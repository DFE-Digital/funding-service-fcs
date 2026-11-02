namespace ContractManagementDomain.Termination.Services
{
    using ContractManagement.DataStore.Repositories;
    using ContractManagementDomain.Termination.DTOs;
    using ContractManagementDomain.Termination.Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public class TerminateContractInfoCreator : ITerminateContractInfoCreator
    {
        private readonly IMonthEndHistoryRepository _monthEndHistoryRepository;
        private readonly IDateProvider _dateProvider;
        private readonly IApprovedContractRepository _approvedContractRepository;
        private readonly ICrmTerminationContractRepository _crmTerminationContractRepository;

        public TerminateContractInfoCreator(
            IMonthEndHistoryRepository monthEndHistoryRepository,
            IDateProvider dateProvider,
            IApprovedContractRepository approvedContractRepository,
            ICrmTerminationContractRepository crmTerminationContractRepository)
        {
            _monthEndHistoryRepository = monthEndHistoryRepository;
            _dateProvider = dateProvider;
            _approvedContractRepository = approvedContractRepository;
            _crmTerminationContractRepository = crmTerminationContractRepository;
        }

        public TerminateContractInfo CreateTerminateContractInfo(ContractIdentifier contractIdentifier, ConnectionInfo connectionInfo)
        {
            SimpleContractTerminationInfo simpleContractTerminationInfo = _crmTerminationContractRepository.GetSimpleContractTerminationInfo(contractIdentifier.ContractNumber,
                contractIdentifier.VersionNumber, contractIdentifier.SubVersionNumber);

            return new TerminateContractInfo(
                isLatest: simpleContractTerminationInfo.IsLatest,
                contractTerminationDate: simpleContractTerminationInfo.TerminationDate,
                contractIdentifier: contractIdentifier,
                hasOutStandingPayments: ci => _approvedContractRepository.HasOutstandingPayments(ci.ContractNumber, ci.VersionNumber, ci.SubVersionNumber, connectionInfo),
                isMonthEndRunning: () => _monthEndHistoryRepository.IsMonthEndInProgress(connectionInfo),
                currentDate: _dateProvider.GetDate(connectionInfo));
        }
    }
}
