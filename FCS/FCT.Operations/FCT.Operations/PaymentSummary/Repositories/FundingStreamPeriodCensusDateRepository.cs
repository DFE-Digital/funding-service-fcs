namespace FCT.Operations.PaymentSummary.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Collections.Generic;
    using System.Reflection;
    using System.IO;


    public class FundingStreamPeriodCensusDateRepository : IFundingStreamPeriodCensusDateRepository
    {
        private const string SqlResourceName = @"FCT.Operations.Resources.PaidCensusDatesPassedForCensusPeriod.sql";
        public async Task<bool> HaveAllPaidCensusDatesPassedForCensusPeriod(DateTime currentTime, ConnectionInfo connectionInfo)
        {
            ReportingPeriod reportingPeriod = new ReportingPeriod(currentTime);
            List<int> pMethod = PaymentLineSummaryRepository.GetPaymentInfo(reportingPeriod.Day);            
            int count = await connectionInfo.Connection.ExecuteScalarAsync<int>(
                sql: GetSqlScriptFromResource(SqlResourceName),
                param: new { currentTime, pMethod },
                transaction: connectionInfo.Transaction,
                commandTimeout: (int)TimeSpan.FromMinutes(1).TotalSeconds)
                .ConfigureAwait(false);

            return count == 0;
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