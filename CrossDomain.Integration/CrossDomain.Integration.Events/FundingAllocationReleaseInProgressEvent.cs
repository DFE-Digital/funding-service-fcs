namespace SFA.FCT.CrossDomain.Integration.Events
{
    public class FundingAllocationReleaseInProgressEvent
    {
        public FundingAllocationReleaseInProgressEvent(string fundingTypeCode, string fundingPeriodName, int releaseGroupGroupId)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
            ReleaseGroupGroupId = releaseGroupGroupId;
        }

        public int ReleaseGroupGroupId { get; }

        public string FundingTypeCode { get; set; }

        public string FundingPeriodName { get; set; }

        public override string ToString()
        {
            return $"FundingTypeCode: {FundingTypeCode}, FundingPeriodName: {FundingPeriodName}, ReleaseGroupGroupId: {ReleaseGroupGroupId}";
        }
    }
}