namespace FCT.Console.Config.Synchronizers.PaaS.Repositories
{
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using Dapper;

    public static class SequenceRepository
    {
        public static IReadOnlyCollection<string> GetExistingSequenceNames(IDbConnection connection)
        {
            string sql = @"SELECT name FROM sys.sequences";

            return connection.Query<string>(sql).ToList();
        }

        public static void CreateSequence(IDbConnection connection, string sequenceName, int startingValue)
        {
            string sql = $@"CREATE SEQUENCE ContractManagement.{sequenceName}  
                            START WITH {startingValue}  
                            INCREMENT BY 1 ;";

            connection.Execute(sql);
        }
    }
}
