namespace AllocationDelivery.Messages.Commands
{
    using DTOs;

    public class ReportedActualsRoutingCommand
    {
        public string PartitionKey { get; set; }

        public SummarisedActualOrgFspGroupKey SummarisedActualOrgFspGroupKey { get; set; }

        public string[] GetPartitionKeys()
        {
            return PartitionKey != null ? new[] { PartitionKey } : new string[] { };
        }

        public SummarisedActualOrgFspGroupKey[] GetSummarisedActualOrgFspGroupKeys()
        {
            return SummarisedActualOrgFspGroupKey != null ? new[] { SummarisedActualOrgFspGroupKey } : new SummarisedActualOrgFspGroupKey[] { };
        }

        public bool IsUsingAzureTableStorage()
        {
            return !string.IsNullOrEmpty(PartitionKey);
        }

        public override string ToString()
        {
            return PartitionKey ?? SummarisedActualOrgFspGroupKey.ToString();
        }

        public string GetPartitionKey()
        {
            if (!string.IsNullOrEmpty(PartitionKey))
            {
                return PartitionKey;
            }

            return SummarisedActualOrgFspGroupKey.GetPartitionKey();
        }
    }
}
