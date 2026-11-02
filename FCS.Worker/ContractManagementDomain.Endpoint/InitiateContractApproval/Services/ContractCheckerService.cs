namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Services
{
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Dtos;

    public class ContractCheckerService : IContractCheckerService
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingPeriodQueryRepository;
        private readonly ICrmContractRepository _crmContractRepository;

        public ContractCheckerService(IFundingTypeFundingPeriodQueryRepository fundingPeriodQueryRepository, ICrmContractRepository crmContractRepository)
        {
            _fundingPeriodQueryRepository = fundingPeriodQueryRepository;
            _crmContractRepository = crmContractRepository;
        }

        public ContractCheckerServiceResult GetContractCheckerServiceResult(string contractNumber, int versionNumber, string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            var isLevy = IsLevy(contractNumber, versionNumber, connectionInfo);

            if (!isLevy) return ContractCheckerServiceResult.NotLevy();

            var isNew = IsNew(contractNumber);

            var isAllocationNew = false;
            if (!isNew)
            {
                isAllocationNew = IsAllocationNew(contractNumber, fundingStreamPeriodCode);
            }
            
            return ContractCheckerServiceResult.GetResult(isNew, isAllocationNew);
        }

        private bool IsNew(string contractNumber)
        {
            return !_crmContractRepository.HasContractBeenApproved(contractNumber);
        }

        private bool IsAllocationNew(string contractNumber, string fundingStreamPeriodCode)
        {
            return _crmContractRepository.LatestContractIncludesAllocation(contractNumber, fundingStreamPeriodCode) &&
                   _crmContractRepository.LastApprovedContractDoesNotIncludeAllocation(contractNumber, fundingStreamPeriodCode);
        }

        private bool IsLevy(string contractNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            var keyDto = _crmContractRepository.GetFundingTypeFundingPeriodKeyDtoForLatestContract(contractNumber, versionNumber);

            var fundingTypeFundingPeriod = _fundingPeriodQueryRepository.Get(keyDto.FundingTypeCode, keyDto.FundingPeriodName, connectionInfo);

            return fundingTypeFundingPeriod.DefaultContractStartDate != null;
        }
    }
}
