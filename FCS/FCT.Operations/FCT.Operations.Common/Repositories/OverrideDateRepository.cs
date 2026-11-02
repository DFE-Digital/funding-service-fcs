namespace SFA.FCT.Operations.Common.Repositories
{
    using System;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Entities.Data;
    using Dapper;

    public class OverrideDateRepository : IOverrideDateRepository
    {
        public async Task<DateTime> GetDate(ConnectionInfo connectionInfo)
        {
            const string sql = @"SELECT [SystemOverrideDate]
                                 FROM [OverrideDate].[OverrideDate]";

            var date = await connectionInfo.Connection
                .ExecuteScalarAsync<DateTime?>(sql, param: new { },
                    transaction: connectionInfo.Transaction);

            if (date == null)
            {
                return DateTime.Now;
            }

            return date.Value;
        }
    }
}
