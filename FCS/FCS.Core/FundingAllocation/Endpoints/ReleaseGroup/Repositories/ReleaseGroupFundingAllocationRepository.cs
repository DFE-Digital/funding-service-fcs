namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Dto;
    using Extensions;
    using Microsoft.EntityFrameworkCore;
    using System.Collections.ObjectModel;

    public class ReleaseGroupFundingAllocationRepository : IReleaseGroupFundingAllocationRepository
    {
        private readonly FundingAllocationContext _context;

        public ReleaseGroupFundingAllocationRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<FundingAllocation> GetFundingAllocationForId(string fundingId)
        {
            return await _context.FundingAllocations
                .AsNoTracking()
                .Include(fa => fa.ProviderFundingAllocations)
                .ThenInclude(pfa => pfa.ProviderFunding)
                .ThenInclude(pf => pf.FundingAllocationLines)
                .ThenInclude(fal => fal.FundingAllocationProfilePeriods)
                .SingleAsync(fa => fa.FundingId == fundingId);
        }

            public async Task<FundingAllocation[]> GetFundingAllocationsWithOfInterestLinesForIds(IEnumerable<string> fundingIds)
        {
            var fundingAllocations = await _context.FundingAllocations
                .AsNoTracking()
                .Include(fa => fa.ProviderFundingAllocations)
                .ThenInclude(pfa => pfa.ProviderFunding)
                .ThenInclude(pf => pf.FundingAllocationLines)
                .ThenInclude(fal => fal.FundingAllocationProfilePeriods)
                .Where(fa => fundingIds.Contains(fa.FundingId))
                .ToArrayAsync();

            var providerFundings = fundingAllocations
                .SelectMany(fa => fa.ProviderFundingAllocations.Select(pfa => pfa.ProviderFunding)).ToList();

            // filter out the lines we don't want, this feature is not available until .Net Core 5 EF
            providerFundings.ForEach(pf => pf.FundingAllocationLines = pf.FundingAllocationLines.Where(l => l.IsOfNoInterest == false).ToList());
            return fundingAllocations;
        }

        public async Task UpdateFundingAllocationsWithContractId(IEnumerable<string> fundingIds, int contractId)
        {
            var result = _context.FundingAllocations.Where(f => fundingIds.Contains(f.FundingId)).ToList();
            if(result!=null)
            {
                result.ForEach(r => r.ContractId = contractId);
                await _context.SaveChangesAsync();
            }
        }

        public async Task RemoveQueuedInfoFromQueuedFundingAllocations(IReadOnlyCollection<string> queuedFundingIds,
            IEnumerable<string> contractNumbers)
        {
            string statusInRelease = FundingAllocationStatus.InRelease.ToString();
            string subStatusQueued = FundingAllocationSubStatus.Queued.ToString();

            const string sql = @"update [FundingAllocation].[FundingAllocation]
                                set Status = NULL,
                                    SubStatus = NULL,
                                    ContractId = NULL
                                where FundingId in @queuedFundingIds
                                and status = @statusInRelease
                                and subStatus = @subStatusQueued
                                and ContractId in (Select id from [FundingAllocation].[Contract] where ContractNumber in @contractNumbers)";

            await _context.Database.GetDbConnection().ExecuteAsync(sql, transaction: _context.CurrentTransaction,
                param: new { queuedFundingIds, statusInRelease, subStatusQueued, contractNumbers });
        }

        public async Task RemoveAnyOrphanedQueuedContracts()
        {
            var queued = RelationshipToFundingAllocationEnum.Queued.ToString();
            const string sql = @"delete from [FundingAllocation].[Contract]
                                 where id NOT in (select ISNULL(fa.ContractId, -1)
                                                 from [FundingAllocation].[FundingAllocation] fa)
                                 and RelationshipToFundingAllocation = @queued";

            await _context.Database.GetDbConnection().ExecuteAsync(
                sql, 
                transaction: _context.CurrentTransaction,
                param:new { queued });
        }

        public async Task<FundingAllocationGroupingInfo[]> GetFundingAllocationGroupingInfos(IEnumerable<string> fundingIds)
        {
            var groupingInfos = await (from fa in _context.FundingAllocations
                                      join pfa in _context.ProviderFundingAllocations on fa.FundingId equals pfa.FundingId
                                      join pf in _context.ProviderFundings on pfa.ProviderFundingId equals pf.ProviderFundingId
                                      where fundingIds.Contains(fa.FundingId)
                                      select new FundingAllocationGroupingInfo(fa.FundingId,
                                      fa.AllocationFundingStream,
                                      fa.Period,
                                      fa.UKPRN,
                                      pf.ProviderType,
                                      pf.ProviderSubType)).Distinct().ToListAsync();
            return groupingInfos.ToArray();
        }

        public async Task<IReadOnlyCollection<int>> GetReleaseGroupIds(IEnumerable<string> fundingIds)
        {
            var groupingInfos = await _context.FundingAllocations
               .Where(fa => fundingIds.Contains(fa.FundingId))
               .Select(fa => (int)fa.ReleaseGroupId).Distinct().ToListAsync();    

            return groupingInfos.ToList();
        }

        public async Task<IReadOnlyCollection<string>> GetMatchingLastApprovedFundingIds(IReadOnlyCollection<string> fundingNames)
        {
            string contractApprovedStatus = FundingAllocationStatus.ContractApproved.ToString();
            string contractApprovedSubStatus = FundingAllocationSubStatus.ContractApproved.ToString();


            var fundingIds = await (from fa in _context.FundingAllocations
                                       where fa.Status==contractApprovedStatus
                                       && fa.SubStatus ==contractApprovedSubStatus
                                       && fundingNames.Contains(fa.FundingAllocationName)
                                       select new FundingIdAndVersion(fa.FundingId,
                                       fa.FundingVersion,
                                       fa.FundingAllocationName)).ToListAsync();

            return fundingIds.ToList().GroupBy(fId => fId.FundingAllocationName).Select(grp =>
            {
                return grp.Select(fid => fid.FundingId.ToFundingIdInfo())
                    .OrderByDescending(info => info.FundingIdVersion)
                    .First()
                    .FundingId;
            }).ToList(); 
        }

        public async Task<IReadOnlyCollection<Guid>> GetFundingAllocationCrmIds(IEnumerable<string> fundingIds)
        {
            var crmEntityIds = await _context.FundingAllocations
                .Where(fa => fundingIds.Contains(fa.FundingId))
                .Select(fa => (Guid)fa.CrmEntityId)
                .ToListAsync();

            return crmEntityIds.ToList();
        }

        private class FundingIdAndVersion
        {
            public FundingIdAndVersion(string fundingId, string fundingVersion, string fundingAllocationName)
            {
                FundingId = fundingId;
                FundingVersion = fundingVersion;
                FundingAllocationName = fundingAllocationName;
            }

            public string FundingId { get; }
            public string FundingVersion { get; }
            public string FundingAllocationName { get; }
        }
    }
}
