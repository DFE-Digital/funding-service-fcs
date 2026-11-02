namespace FundingAllocation.Repositories
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Dto;
    using LanguageExt;
    using Microsoft.EntityFrameworkCore;

    public class ReleaseGroupRepository : IReleaseGroupRepository
    {
        private readonly FundingAllocationContext _fundingAllocationContext;

        public ReleaseGroupRepository(FundingAllocationContext fundingAllocationContext)
        {
            _fundingAllocationContext = fundingAllocationContext;
        }

        public async Task<Option<ReleaseGroupId>> GetAwaitingReleaseGroup(string fundingTypeCode, string fundingPeriod, string fspGroupCode, string contractType)
        {
            string awaitingReleaseStatus = ReleaseGroupStatus.AwaitingRelease.ToString();
            var ids = await (from r in _fundingAllocationContext.ReleaseGroups
                             where r.FundingTypeCode == fundingTypeCode &&
                             r.FundingPeriodCode == fundingPeriod &&
                             r.FSPGroupCode == fspGroupCode &&
                             r.ContractType == contractType &&
                             r.Status == awaitingReleaseStatus
                             select new ReleaseGroupId(r.Id, r.CrmEntityId)).ToListAsync();

            return ids.SingleOrDefault();
        }

        public async Task<int> CreateReleaseGroup(string fundingTypeCode, string fundingPeriod, string fspGroupCode, 
            string contractType, Guid crmReleaseGroupEntityId, string releaseGroupName)
        {   
            ReleaseGroup releaseGroup = new ReleaseGroup(fundingTypeCode, fundingPeriod, fspGroupCode, 
                contractType, crmReleaseGroupEntityId, releaseGroupName);

            await _fundingAllocationContext.ReleaseGroups.AddAsync(releaseGroup);

            await _fundingAllocationContext.SaveChangesAsync();

            return releaseGroup.Id;
        }

        public async Task<string> GetNextReleaseGroupName()
        {
            var nextSequence =  await _fundingAllocationContext.Database.GetDbConnection().ExecuteScalarAsync<int>($"SELECT NEXT VALUE FOR [FundingAllocation].[ReleaseGroup_seq]",
                transaction: _fundingAllocationContext.CurrentTransaction);

            return $"RG{nextSequence}";
        }
    }
}
