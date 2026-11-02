namespace AllocationDelivery.Messages.Commands
{
    using DTOs;

    public class ReportedPaymentInstructionsLoadedCommand
    {
        public string PartitionKey { get; set; }

        public SummarisedActualOrgFspGroupKey SummarisedActualOrgFspGroupKey { get; set; }

        public override string ToString()
        {
            return PartitionKey ?? SummarisedActualOrgFspGroupKey.ToString();
        }
    }
}
