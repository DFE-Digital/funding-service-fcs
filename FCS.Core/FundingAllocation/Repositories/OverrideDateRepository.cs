namespace FundingAllocation.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using Microsoft.EntityFrameworkCore;

    public class OverrideDateRepository : IOverrideDateRepository
    {
        private readonly FundingAllocationContext _context;

        public OverrideDateRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<DateTime> GetDate()
        {
            const string sql = @"SELECT [SystemOverrideDate]
                                 FROM [OverrideDate].[OverrideDate]";

            var date = await _context.Database.GetDbConnection()
                .ExecuteScalarAsync<DateTime?>(sql, param: new { },
                    transaction: _context.CurrentTransaction);

            if (date == null)
            {
                return DateTime.Now;
            }

            return date.Value;
        }
    }
}
