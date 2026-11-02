namespace FundingAllocation.Dto
{
    using System.Collections.Generic;

    public class ReleaseGroupNameValidationResult
    {
        public ReleaseGroupNameValidationResult(IReadOnlyCollection<string> validReleaseGroupNames, IReadOnlyCollection<string> releaseGroupNamesWithFundingInfoBulkUploadedInProgress)
        {
            ValidReleaseGroupNames = validReleaseGroupNames;
            ReleaseGroupNamesWithFundingInfoBulkUploadedInProgress = releaseGroupNamesWithFundingInfoBulkUploadedInProgress;
        }

        public IReadOnlyCollection<string> ValidReleaseGroupNames { get; }
        public IReadOnlyCollection<string> ReleaseGroupNamesWithFundingInfoBulkUploadedInProgress { get; }

        public override string ToString() =>
            $"ValidReleaseGroupNames: {ValidReleaseGroupNames.Count}, ReleaseGroupNamesWithFundingInfoBulkUploadedInProgress:{ReleaseGroupNamesWithFundingInfoBulkUploadedInProgress.Count}";
    }
}
