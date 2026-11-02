namespace AllocationDelivery.Messages.DTOs
{
    public class SummarisedActualOrgFspGroupKey
    {
        public string CollectionType { get; set; }

        public string CollectionReturnCode { get; set; }

        public string OrganisationId { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public string UopCode { get; set; }

        public string GetPartitionKey()
        {
            return $"{CollectionType}{CollectionReturnCode}_{OrganisationId}{FundingStreamPeriodCode}{UopCode}";
        }

        public override string ToString() =>
            $"CollectionType: {CollectionType}, CollectionReturnCode: {CollectionReturnCode}, OrganisationId: {OrganisationId}, FundingStreamPeriodCode: {FundingStreamPeriodCode}, UopCode: {UopCode}";
    }
}