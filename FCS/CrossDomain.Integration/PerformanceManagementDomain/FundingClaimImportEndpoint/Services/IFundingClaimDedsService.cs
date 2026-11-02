namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System;
    using System.Collections.Generic;

    public interface IFundingClaimDedsService
    {
        Guid GetLatestPublishedDataSetVersionId();

        IEnumerable<string> GetFundingClaimCompletedCollections(Guid dataSetVersionId, DateTime dateTime);

        IEnumerable<string> GetFundingClaimsThatAreCompleted(Guid dataSetVersionId, string dataCollectionKey,
            int? pageSize, int? pageNumber);

        int GetFundingClaimsThatAreCompletedCount(Guid dataSetVersionId, string dataCollectionKey);
    }
}
