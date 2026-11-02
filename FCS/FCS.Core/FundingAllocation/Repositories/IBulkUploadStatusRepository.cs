namespace FundingAllocation.Repositories
{
    using System;
    using System.Threading.Tasks;

    public interface IBulkUploadStatusRepository
    {
        Task SetToInProgress(Guid bulkUploadBatchId, string fundingTypeCode, string fundingPeriodName);

        Task SetToLoaded(string bulkUploadBatchId);

        Task<bool> IsInProgress(string fundingTypeCode, string fundingPeriodName);
    }
}