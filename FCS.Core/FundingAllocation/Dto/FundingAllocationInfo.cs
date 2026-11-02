namespace FundingAllocation.Dto
{
    using System;
    using Extensions;

    public class FundingAllocationInfo
    {
        public FundingAllocationInfo(string fundingId, string crmEntityId)
        {
            FundingId = fundingId;
            CrmEntityId = crmEntityId;
        }

        public string FundingId { get; }
        public string CrmEntityId { get; }
        public string FundingAllocationName => FundingId.RemoveVersionFromId();
    }
}
