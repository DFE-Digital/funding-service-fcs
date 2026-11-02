namespace SFA.FCT.PerformanceManagementDomain.Common.Commands
{
    using System;

    public class FundingClaimPagedRequestCommand
    {
        public FundingClaimPagedRequestCommand()
        {
        }

        public FundingClaimPagedRequestCommand(Guid datasetVersion, string closedCollectionKey, int pageNumber)
        {
            if (datasetVersion == Guid.Empty || string.IsNullOrEmpty(closedCollectionKey))
            {
                throw new ArgumentException("datasetVersion and closedCollectionKey must not be null or empty");
            }

            DatasetVersionId = datasetVersion;
            ClosedCollectionKey = closedCollectionKey;
            PageNumber = pageNumber;
        }
        public Guid DatasetVersionId { get; set; }

        public string ClosedCollectionKey { get; set; }

        public int PageNumber { get; set; }
    }
}
