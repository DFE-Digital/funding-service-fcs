namespace FundingAllocation.Endpoints.CreateFundingAllocationInCrm
{
    public class CrmFundingAllocationFks
    {
        public CrmFundingAllocationFks(string fundingTypeId, string periodId, string providerId, string contractTypeId, string fspGroupId)
        {
            FundingTypeId = fundingTypeId;
            PeriodId = periodId;
            ProviderId = providerId;
            ContractTypeId = contractTypeId;
            FspGroupId = fspGroupId;
        }

        public string FundingTypeId { get; }

        public string PeriodId { get; }

        public string ProviderId { get; }

        public string ContractTypeId { get; }

        public string FspGroupId { get; }

        public string ReleaseGroupId { get; set; }
    }
}
