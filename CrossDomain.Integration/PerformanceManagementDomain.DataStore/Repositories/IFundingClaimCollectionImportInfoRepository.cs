namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System;
    using Models;

    public interface IFundingClaimCollectionImportInfoRepository
    {
        DateTime? GetLastCompletedImportDate();

        void AddRowOrUpdate(FundingClaimCollectionImportInfo fundingClaimCollectionImportInfo);

        FundingClaimCollectionImportInfo Find(string periodClaimType);
    }
}
