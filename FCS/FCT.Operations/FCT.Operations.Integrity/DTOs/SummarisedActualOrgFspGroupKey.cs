namespace SFA.FCT.Operations.Integrity.DTOs
{
    public class SummarisedActualOrgFspGroupKey
    {
       
        public SummarisedActualOrgFspGroupKey(string collectionType, string collectionReturnCode, string organisationId, string fundingStreamPeriodCode, string uopCode)
        {
            CollectionType = collectionType;
            CollectionReturnCode = collectionReturnCode;
            OrganisationId = organisationId;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            UopCode = uopCode;
        }

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