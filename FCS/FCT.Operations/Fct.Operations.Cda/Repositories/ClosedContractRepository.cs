namespace FCT.Operations.Cda.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.IO;
    using System.Reflection;

    public class ClosedContractRepository : IClosedContractRepository
    {

        private const string SqlResourceName = @"FCT.Operations.Cda.Sql.GetContractNumbersClosedInPreviousYears.sql";
        public async Task<IReadOnlyCollection<(string contractNumber, int year)>> GetContractNumbersClosedInPreviousYears(
            IEnumerable<string> fspCodes,
            int lastYear,
            ConnectionInfo connectionInfo)
        {
            const int closedContractAtomItemType = 3;
            const int terminatedContractAtomItemType = 6;
            var closedAtomItemTypes = new List<int> { closedContractAtomItemType, terminatedContractAtomItemType };
            var rows = await connectionInfo.Connection.QueryAsync<(string contractNumber, int year)>(
                 sql: GetSqlScriptFromResource(SqlResourceName),
                transaction: connectionInfo.Transaction,
                commandTimeout:(int)TimeSpan.FromMinutes(10).TotalSeconds,
                param: new { fspCodes, lastYear, closedAtomItemTypes });

            return rows.ToList();
        }

        private static string GetSqlScriptFromResource(string sqlResourceName)
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(sqlResourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }
    }
}
