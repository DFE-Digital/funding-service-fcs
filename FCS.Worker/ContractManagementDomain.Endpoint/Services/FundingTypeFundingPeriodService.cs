namespace ContractManagementDomain.Endpoint.Services
{
    using System;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;

    public class FundingTypeFundingPeriodService : IFundingTypeFundingPeriodService
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly IDateProvider _currentDateProvider;

        public FundingTypeFundingPeriodService(IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository, IDateProvider currentDateProvider)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _currentDateProvider = currentDateProvider;
        }

        public bool IsProcessDateAfterFundingTypeContractingActivityCloseDate(string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo)
        {
            FundingTypeFundingPeriod fundingTypeFundingPeriod = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName, connectionInfo);

            return fundingTypeFundingPeriod.IsDateAfterContractActivityClose(_currentDateProvider.GetDate(connectionInfo));
        }


        public ContractApprovalType GetApprovalType(string fundingTypeCode, string fundingPeriodName)
        {
            var approvalType = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriodName).ApprovalType;
            return (ContractApprovalType)Enum.Parse(typeof(ContractApprovalType), approvalType);
        }

        public bool IsLEVYAllocationSynced(string contractNo, int contractversionNo, int contractsubversionNo, int allocationCount)
        {
            return _fundingTypeFundingPeriodQueryRepository.IsLEVYAllocationSynced(contractNo,contractversionNo,contractsubversionNo, allocationCount);  
        }
    }
}