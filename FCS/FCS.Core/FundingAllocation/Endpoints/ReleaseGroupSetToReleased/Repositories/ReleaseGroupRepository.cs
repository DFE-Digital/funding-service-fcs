namespace FundingAllocation.Endpoints.ReleaseGroupSetToReleased.Repositories
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;
    using Dto;

    public class ReleaseGroupRepository : IReleaseGroupRepository
    {
        private readonly FundingAllocationContext _context;

        public ReleaseGroupRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<string> GetCrmEntityId(string releaseGroupName)
        {
            var crmEntityId = await _context.ReleaseGroups.Where(rg => rg.ReleaseGroupName == releaseGroupName)
                .AsNoTracking()
                .Select(rg => rg.CrmEntityId)
                .SingleAsync();

            return crmEntityId.ToString();
        }

        public async Task<bool> SetToReleasedIfNotAlready(string releaseGroupName)
        {

            var numRowsChanged = _context.ReleaseGroups.Where(rg => rg.ReleaseGroupName == releaseGroupName
            && rg.Status != "Released").ToList();
            if (numRowsChanged.Any())
            {
                numRowsChanged.ForEach(r =>
                {
                    r.Status = "Released";
                    r.ReleasedDate = DateTime.Now;
                });
                await _context.SaveChangesAsync();
            }

            return numRowsChanged.Count == 1;
        }

        public async Task<FundingTypeFundingPeriod> GetFundingTypeFundingPeriod(string releaseGroupName)
        {
            var fundingTypeFundingPeriod = await (from rg in _context.ReleaseGroups
                                                             where rg.ReleaseGroupName==releaseGroupName
                                                             select new FundingTypeFundingPeriod(rg.FundingTypeCode,
                                                             rg.FundingPeriodCode)).SingleAsync();

            return fundingTypeFundingPeriod;
        }

        public async Task<bool> IsReleaseGroupGroupReleased(string releaseGroupName)
        {
            string releasedStatus = ReleaseGroupStatus.Released.ToString();

            var count = await _context.Database.GetDbConnection().ExecuteScalarAsync<int>
            ("sp_FA_IsReleaseGroupGroupReleased @releaseGroupName,@releasedStatus", param: new { releaseGroupName, releasedStatus },
                transaction: _context.CurrentTransaction);

            return count == 0;
        }

        public async Task<int> GetReleaseGroupGroupId(string releaseGroupName)
        {
            return await (from rgg in _context.ReleaseGroupGroups
                          join rg in _context.ReleaseGroups on rgg.ReleaseGroupId equals rg.Id
                          where rg.ReleaseGroupName == releaseGroupName
                          select rgg.ReleaseGroupGroupId).Distinct().SingleOrDefaultAsync();
        }
    }
}