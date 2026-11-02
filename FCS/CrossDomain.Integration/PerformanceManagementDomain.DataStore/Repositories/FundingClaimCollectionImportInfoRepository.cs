namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System;
    using System.Linq;
    using Models;

    public class FundingClaimCollectionImportInfoRepository : PerformanceManagementRepositoryBase<FundingClaimCollectionImportInfo>, IFundingClaimCollectionImportInfoRepository
    {
        private readonly IPerformanceManagementDbContext _dbContext;

        public FundingClaimCollectionImportInfoRepository(IPerformanceManagementDbContext dbContext)
            : base(dbContext.FundingClaimCollectionImportInfos)
        {
            _dbContext = dbContext;
        }

        public DateTime? GetLastCompletedImportDate()
        {
            return RetrieveAll()
                .OrderByDescending(x => x.ImportCompletedDate)
                .FirstOrDefault()
                ?.ImportCompletedDate;
        }

        public void AddRowOrUpdate(FundingClaimCollectionImportInfo fundingClaimCollectionImportInfo)
        {
            FundingClaimCollectionImportInfo infoForCollectionKey = FindByKey(new[] { fundingClaimCollectionImportInfo.PeriodClaimType });

            if (infoForCollectionKey != null)
            {
                infoForCollectionKey.ImportCompletedDate = fundingClaimCollectionImportInfo.ImportCompletedDate;
                infoForCollectionKey.TotalRowsToImport = fundingClaimCollectionImportInfo.TotalRowsToImport;
            }
            else
            {
                AddEntity(fundingClaimCollectionImportInfo);
            }

            _dbContext.SaveChanges();
        }

        public FundingClaimCollectionImportInfo Find(string periodClaimType)
        {
            return FindByKey(new []{periodClaimType});
        }
    }
}
