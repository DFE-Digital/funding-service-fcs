using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace SFA.FCT.CrossDomain.Integration.Common.Repositories
{
    public class DapperQueryExecutor : IDapperQueryExecutor
    {
        public Task<IEnumerable<T>> QueryAsync<T>(IDbConnection connection, string sql, object parameters)
        {
            return connection.QueryAsync<T>(sql, parameters);
        }
    }
}
