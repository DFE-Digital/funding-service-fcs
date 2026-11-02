namespace ContractManagement.DataStore.Repositories
{
    using System.Data;
    using Model;
    using Dapper;

    public class IntegrityCheckRepository : IIntegrityCheckRepository
    {
        private readonly IDbConnection _connection;

        public IntegrityCheckRepository(IDbConnection connection)
        {
            _connection = connection;
        }

        public IntegrityCheck Add(IntegrityCheck integrityCheck)
        {
            const string sql =
                "Insert into [ContractManagement].[IntegrityCheck] (CheckerType, StartDate, Status)" +
                "OUTPUT INSERTED.Id values (@checkerType, @startDate, @status) ";
            integrityCheck.Id = _connection.QuerySingle<int>(sql, param: integrityCheck);

            return integrityCheck;
        }


        public void Update(IntegrityCheck integrityCheck)
        {
            const string sql = @"UPDATE[ContractManagement].[IntegrityCheck]
                                SET [Status] = @status
        		                    ,[FinishDate] = @finishDate
                                    ,[Outcome] = @outcome
                                    ,[Link] = @link
                                WHERE Id = @id";

            _connection.Execute(sql, param: integrityCheck);
        }
    }
}
