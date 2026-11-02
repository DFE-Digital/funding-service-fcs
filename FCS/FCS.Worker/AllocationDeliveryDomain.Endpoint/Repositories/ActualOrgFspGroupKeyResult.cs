namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    public class ActualOrgFspGroupKeyResult
    {
        public ActualOrgFspGroupKeyResult()
        {

        }
            public ActualOrgFspGroupKeyResult(string organisationId, string fundingStreamPeriodCode, string uopCode)
        {
            OrganisationId = organisationId;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            UopCode = uopCode;
        }

        public string OrganisationId { get; set; }
        public string FundingStreamPeriodCode { get; set; }
        public string UopCode { get; set; }
    }
}
