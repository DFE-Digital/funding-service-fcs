namespace FundingAllocation.Dto
{
    public class FspCodeDeliverable
    {
        public FspCodeDeliverable(string fspCode, int deliverableCode, string deliverableName, int displayOrder, string fundingStreamCode, string allocationReferencePrefix)
        {
            FspCode = fspCode;
            DeliverableCode = deliverableCode;
            DeliverableName = deliverableName;
            DisplayOrder = displayOrder;
            FundingStreamCode = fundingStreamCode;
            AllocationReferencePrefix = allocationReferencePrefix;
        }

        public string FspCode { get; }

        public int DeliverableCode { get; }

        public string DeliverableName { get; }

        public int DisplayOrder { get; }
        public string FundingStreamCode { get; }

        public string AllocationReferencePrefix { get; }

    }
}