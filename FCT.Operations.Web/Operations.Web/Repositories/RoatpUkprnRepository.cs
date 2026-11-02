namespace Operations.Web.Repositories
{
    using ContractManagement.DataStore;
    using Dapper;
    using Operations.Web.Dtos;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;

    public class RoatpUkprnRepository : IRoatpUkprnRepository
    {
        private readonly IContractManagementDbContext _contractManagementDbContext;

        public RoatpUkprnRepository(IContractManagementDbContext contractManagementDbContext)
        {
            _contractManagementDbContext = contractManagementDbContext;
        }

        public IReadOnlyCollection<string> GetValidUkprns()
        {
           return _contractManagementDbContext.RoatpProviders.Select(r => r.Ukprn).ToList(); 
        }

        public async Task<bool> GetStatusOfEngagmenetWatcherWebjob(string webjobname)
        {
            var connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
             
            SqlConnection connection = new SqlConnection(connectionString);

            const string sql = @"select  [Enabled] 
                                from ContractRequest.WebjobStatus
                                where Webjobname = @webjobname";

            
            var rows = await connection.QueryAsync<bool>(sql, param: new { webjobname }).ConfigureAwait(false);
            if (!rows.Any())
            {
                const string insertSql = @"Insert into ContractRequest.WebjobStatus
                        values ('EngagmenetWatcherWebjob', 1, getdate())";
                
                await connection.QueryAsync<int>(insertSql);
                
                await GetStatusOfEngagmenetWatcherWebjob("EngagmenetWatcherWebjob");
            }
            return rows.FirstOrDefault();
        }

        public async Task UpdateStatusOfEngagementWatcherWebJobStatus(string webjobname, bool enabled, string username)
        {
            DateTime updatedTime = DateTime.UtcNow;
            var connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
             
            SqlConnection connection = new SqlConnection(connectionString);

            const string sql = @"Update ContractRequest.WebjobStatus 
                                    set  [Enabled] = @enabled  ,
                                         ModifiedBy = @username,
                                         ModifiedDate = @updatedTime
                                where Webjobname = @webjobname";

            await connection.QueryAsync<bool>(sql, param: new { webjobname, enabled, username, updatedTime });
        }
    }
}