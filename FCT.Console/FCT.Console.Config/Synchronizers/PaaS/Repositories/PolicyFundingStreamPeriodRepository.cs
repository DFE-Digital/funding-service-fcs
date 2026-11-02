namespace FCT.Console.Config.Synchronizers.PaaS.Repositories
{
    using System.Data;
    using Dapper;

    public static class PolicyFundingStreamPeriodRepository
    {
        public static void UpdateIsPrioritisedApportionment(IDbConnection connection)
        {           
            connection.Execute("sp_Policycache_UpdateIsPrioritisedApment", commandType: CommandType.StoredProcedure);
        }
    }
}