namespace FundingAllocation.Repositories
{
    using System;
    using Microsoft.EntityFrameworkCore;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using LanguageExt;
    using System.Linq;
    using System.Data;

    public class BulkUploadStatusRepository : IBulkUploadStatusRepository
    {
        private readonly FundingAllocationContext _context;

        public BulkUploadStatusRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task SetToInProgress(Guid bulkUploadBatchId, string fundingTypeCode, string fundingPeriodName)
        {
            var status = BulkUploadStatus.UploadStatus.InProgress.ToString();

            await _context.BulkUploadStatuses.AddAsync(new BulkUploadStatus(bulkUploadBatchId, fundingTypeCode,
                fundingPeriodName, status));

            await _context.SaveChangesAsync();
        }

        public async Task SetToLoaded(string bulkUploadBatchId)
        {
            var status = BulkUploadStatus.UploadStatus.Loaded.ToString();
           
                         await (from res in _context.BulkUploadStatuses
                          where res.BulkUploadBatchId.ToString() == bulkUploadBatchId
                          select res).ForEachAsync(x => x.Status = status);
                         await _context.SaveChangesAsync();
          
        }

        public async Task<bool> IsInProgress(string fundingTypeCode, string fundingPeriodName)
        {
            var inProgressStatus = BulkUploadStatus.UploadStatus.InProgress.ToString();

            var numRows = await (from res in _context.BulkUploadStatuses
                                 where res.FundingTypeCode == fundingTypeCode
                          && res.FundingPeriodName == fundingPeriodName
                          && res.Status == inProgressStatus
                                 select res).Take(1).CountAsync();
            return numRows > 0;
        }
    }
}