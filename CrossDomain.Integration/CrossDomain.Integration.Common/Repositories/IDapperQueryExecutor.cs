using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace SFA.FCT.CrossDomain.Integration.Common.Repositories
{
    public interface IDapperQueryExecutor
    {
        Task<IEnumerable<T>> QueryAsync<T>(IDbConnection connection, string sql, object parameters);
    }
}
