namespace Operations.Web.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using Dapper;
    using ContractManagement.DataStore;
    using System.Linq;
    using System.Data.Entity;


    public class MonthEndRepository : IMonthEndRepository
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

        public async Task<DateTime?> GetLatestEndTime()
        {
            using (var context = new ContractManagementDbContext())
            {
                var result = await (from res in context.MonthEndHistories
                                    orderby res.StartTime 
                                    descending select res.EndTime).Take(1).SingleOrDefaultAsync();
                return result;
            }

        }
    }
}