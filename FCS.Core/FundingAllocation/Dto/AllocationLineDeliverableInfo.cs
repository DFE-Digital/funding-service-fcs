namespace FundingAllocation.Dto
{
    public class AllocationLineDeliverableInfo
    {
        public AllocationLineDeliverableInfo(string fspCode, int deliverableCode, string providerCategory, string deliverableName, int displayOrder, string fundingStreamCode, string allocationReferencePrefix)
        {
            FspCode = fspCode;
            DeliverableCode = deliverableCode;
            ProviderCategory = providerCategory;
            DeliverableName = deliverableName;
            DisplayOrder = displayOrder;
            FundingStreamCode = fundingStreamCode;
            AllocationReferencePrefix = allocationReferencePrefix;
        }

        public string FspCode { get; }
        public int DeliverableCode { get; }
        public string ProviderCategory { get; }
        public string DeliverableName { get; }
        public int DisplayOrder { get; }
        public string FundingStreamCode { get; }
        public string AllocationReferencePrefix { get; }
    }
}
