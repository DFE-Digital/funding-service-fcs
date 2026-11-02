namespace SFA.FCT.CrossDomain.Integration.Events
{
    public class BulkUploadInProgressEvent
    {
        public BulkUploadInProgressEvent(string fundingTypeCode, string fundingPeriodName, string batchId)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
            BatchId = batchId;
        }

        public string FundingTypeCode { get; }
        public string FundingPeriodName { get; }
        public string BatchId { get; }

        public override string ToString() =>
            $"FundingTypeCode: {FundingTypeCode}, FundingPeriodName: {FundingPeriodName}, BatchId: {BatchId}";
    }
}
