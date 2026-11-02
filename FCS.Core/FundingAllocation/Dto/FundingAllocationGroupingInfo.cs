namespace FundingAllocation.Dto
{
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class FundingAllocationGroupingInfo
    {
        public FundingAllocationGroupingInfo(
            string fundingId,
            string allocationFundingStreamCode,
            string allocationPeriodId,
            string contractingUkprn,
            string providerType,
            string providerSubType)
        {
            FundingId = fundingId;
            AllocationFundingStreamCode = allocationFundingStreamCode;
            AllocationPeriodId = allocationPeriodId;
            ContractingUkprn = contractingUkprn;
            ProviderType = providerType;
            ProviderSubType = providerSubType;
        }

        public string FundingId { get; }

        public string AllocationFundingStreamCode { get; }
        
        public string AllocationPeriodId { get; }
        
        public string ContractingUkprn { get; }
        
        public string ProviderType { get; }
        
        public string ProviderSubType { get; }

        public ContractItemsMappingInput GetContractItemsMappingInput => new ContractItemsMappingInput(
            AllocationFundingStreamCode, AllocationPeriodId, ProviderType, ProviderSubType, ContractingUkprn);
    }
}
