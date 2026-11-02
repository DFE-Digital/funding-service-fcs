using SFA.FCT.Contracts.AcceptanceTests;
namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;    
    public static class OverrideDateRepository
    {
        public static void SetDate(DateTime date)
        {      
            using (var connection = new SqlConnection(SFA.FCT.Contracts.AcceptanceTests.SqlConnectionStringProvider.Get("ContractManagementDbContext")))
            {
                connection.Execute("sp_config_update_overridedate @date", new { date });
            }
        }
    }
}
