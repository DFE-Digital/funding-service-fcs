namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Collections.Generic;
    using System.Data.Common;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Dto;
    using Extensions;
    using LanguageExt;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Infrastructure;

    public class ReleaseGroupRepository : IReleaseGroupRepository
    {
        private readonly FundingAllocationContext _context;

        public ReleaseGroupRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<IReadOnlyCollection<string>> GetFundingIds(IEnumerable<string> releaseGroupNames)
        {
            var fundingIds = await (from rg in _context.ReleaseGroups
                                      join fa in _context.FundingAllocations on rg.Id equals fa.ReleaseGroupId
                                      where releaseGroupNames.Contains(rg.ReleaseGroupName)
                                      select fa.FundingId).ToListAsync();

            return fundingIds.ToList();
        }

        public async Task<IReadOnlyCollection<string>> GetQueuedFundingIds(IEnumerable<string> releaseGroupNames, IReadOnlyCollection<string> relatedContractNumbers)
        {
            var inReleaseStatus = FundingAllocationStatus.InRelease.ToString();
            var queuedSubStatus = FundingAllocationSubStatus.Queued.ToString();


            const string sql = @"SELECT fa.FundingId
                                FROM [FundingAllocation].[ReleaseGroup] rg
                                    INNER JOIN [FundingAllocation].[FundingAllocation] fa  WITH (ROWLOCK, XLOCK)
                                    ON rg.Id = fa.ReleaseGroupId
                                WHERE rg.ReleaseGroupName IN @releaseGroupNames
                                AND fa.Status = @inReleaseStatus
                                AND fa.SubStatus = @queuedSubStatus
                                AND fa.ContractId in (select id from [FundingAllocation].[Contract] where ContractNumber in @relatedContractNumbers)";

            var fundingIds = await _context.Database.GetDbConnection().QueryAsync<string>(sql, new
                {
                    releaseGroupNames,
                    inReleaseStatus,
                    queuedSubStatus,
                    relatedContractNumbers
            },
                transaction: _context.CurrentTransaction);

            return fundingIds.ToList();
        }

        public async Task<Option<int>> GetReleaseInProgressReleaseGroup(string fundingTypeCode, string fundingPeriod,
            string fspGroupCode, string contractType)
        {
            string releaseInProgressStatus = ReleaseGroupStatus.ReleaseInProgress.ToString();

            var ids = await (from rg in _context.ReleaseGroups
                                    where rg.FundingTypeCode==fundingTypeCode
                                    && rg.FSPGroupCode==fspGroupCode
                                    && rg.ContractType==contractType
                                    && rg.Status==releaseInProgressStatus
                                    select rg.Id).ToListAsync();

            return ids.SingleOrDefault();
        }

        public async Task<IReadOnlyCollection<ReleaseGroupInfo>> GetReleaseGroupInfos(IEnumerable<string> releaseGroupNames)
        {
            var rgs = await _context.ReleaseGroups.Where(rg => releaseGroupNames.Contains(rg.ReleaseGroupName))
                .Select(rg => new {rg.Id, rg.FundingTypeCode, rg.FundingPeriodCode})
                .ToListAsync();

            return rgs.Select(rg => new ReleaseGroupInfo(rg.Id, rg.FundingTypeCode, rg.FundingPeriodCode)).ToList();
        }

        public async Task InsertReleaseGroupGroups(IReadOnlyCollection<ReleaseGroupGroup> releaseGroupGroups)
        {
            await _context.ReleaseGroupGroups.AddRangeAsync(releaseGroupGroups);

            await _context.SaveChangesAsync();
        }

        public async Task<int> GetNextReleaseGroupGroupId()
        {
            return await _context.Database.GetDbConnection().ExecuteScalarAsync<int>($"SELECT NEXT VALUE FOR [FundingAllocation].[ReleaseGroupGroupId_seq]",
                transaction: ((IInfrastructure<DbTransaction>)_context.Database.CurrentTransaction)?.Instance);
        }

        public async Task<IReadOnlyCollection<string>> GetCrmEntityIds(IEnumerable<string> releaseGroupNames)
        {
            const string sql = @"SELECT CAST([CrmEntityId] as NVARCHAR(100))
                                   FROM [FundingAllocation].[ReleaseGroup]
                                  WHERE [ReleaseGroupName] IN @releaseGroupNames";

            var crmEntityIds = await _context.Database.GetDbConnection().QueryAsync<string>(sql, new { releaseGroupNames },
                transaction: _context.CurrentTransaction);

            return crmEntityIds.ToList();
        }

        public async Task<ReleaseGroupNameValidationResult> GetReleaseGroupNameValidationResult(IReadOnlyCollection<string> releaseGroupNames)
        {
            string bulkUploadInProgress = BulkUploadStatus.UploadStatus.InProgress.ToString();

            var releaseGroupsInProgressInBulkUpdate = await (from rg in _context.ReleaseGroups
                             join bus in _context.BulkUploadStatuses on rg.FundingTypeCode equals bus.FundingTypeCode
                             where releaseGroupNames.Contains(rg.ReleaseGroupName)
                             && rg.FundingPeriodCode == bus.FundingPeriodName
                             && bus.Status == bulkUploadInProgress
                             select rg.ReleaseGroupName).ToListAsync();

            var validReleaseGroupNames = releaseGroupNames.WhereNotIn(releaseGroupsInProgressInBulkUpdate);

            return new ReleaseGroupNameValidationResult(validReleaseGroupNames, releaseGroupsInProgressInBulkUpdate);
        }

        public async Task UpdateStatus(IEnumerable<string> releaseGroupNames, ReleaseGroupStatus status)
        {
            string statusString = status.ToString();

            var result = _context.ReleaseGroups.Where(rg => releaseGroupNames.Contains(rg.ReleaseGroupName)).ToList();
            if (result != null)
            {
                result.ForEach(r => r.Status = statusString);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IReadOnlyCollection<ReleaseGroupNameFundingTypeFundingPeriodInfo>> 
            GetReleaseGroupNameFundingTypeFundingPeriodInfos(IEnumerable<string> releaseGroupNames)
        {
            var rgs = await _context.ReleaseGroups.Where(rg => releaseGroupNames.Contains(rg.ReleaseGroupName))
                .Select(rg => new { rg.ReleaseGroupName, rg.FundingTypeCode, rg.FundingPeriodCode })
                .ToListAsync();

            return rgs.Select(rg => 
                new ReleaseGroupNameFundingTypeFundingPeriodInfo(rg.ReleaseGroupName, rg.FundingTypeCode, rg.FundingPeriodCode)).ToList();
        }
    }
}