namespace SFA.FCT.PerformanceManagementDomain.Common.Commands
{
    using System;

    public class ClosedFundingClaimCollectionCommand
    {
        public ClosedFundingClaimCollectionCommand()
        {
        }

        public ClosedFundingClaimCollectionCommand(Guid datasetVersionId, string claimTypePeriodKey)
        {
            DatasetVersionId = datasetVersionId;
            ClaimTypePeriodKey = claimTypePeriodKey;
        }

        public Guid DatasetVersionId { get; set; }

        public string ClaimTypePeriodKey { get; set; }
    }
}
