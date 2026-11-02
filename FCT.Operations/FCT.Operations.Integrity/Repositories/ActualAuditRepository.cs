namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Data;
    using Dapper;

    public class ActualAuditRepository
    {
        private readonly IDbConnection _connection;

        public ActualAuditRepository(IDbConnection connection)
        {
            _connection = connection;
        }

        public int GetAllocationVersionAtCollectionReturn(string allocationNumber, string collectionType, string collectionReturnCode)
        {
           return _connection.QuerySingle<int>("sp_Operation_GetAllocationVersionAtCollectionReturn @allocationNumber,@collectionType,@collectionReturnCode", new { allocationNumber, collectionType, collectionReturnCode });

        }
    }
}
