namespace FundingAllocation.DataStore.Model
{
    using System;
    using Extensions;

    public class BulkUploadStatus
    {
        public enum UploadStatus
        {
            NotSet,
            InProgress,
            Loaded
        }

        public BulkUploadStatus()
        {
            
        }

        public BulkUploadStatus(Guid bulkUploadBatchId, string fundingTypeCode, string fundingPeriodName, string status)
        {
            BulkUploadBatchId = bulkUploadBatchId;
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
            Status = status;
        }

        public Guid BulkUploadBatchId { get; set; }

        public string FundingTypeCode { get; set; }

        public string FundingPeriodName { get; set; }

        public string Status { get; set; }

        public UploadStatus BulkUploadProgressStatus
        {
            get
            {
                if (Status.HasValue())
                {
                    return (UploadStatus)Enum.Parse(typeof(UploadStatus), Status);
                }

                return UploadStatus.NotSet;
            }
            set => Status = (value != UploadStatus.NotSet) ? value.ToString() : null;
        }
    }
}