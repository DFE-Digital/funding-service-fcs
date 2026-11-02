namespace FCT.Operations.FundingConfirmationReport.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Data;


    public class LAFundingConfirmationReportRepository : ILAFundingConfirmationReportRepository
    {
        const int twoFourtySeconds = 240;
        //public async Task<int> GetLALatestPeriodFromConfig(ConnectionInfo connectionInfo)
        //{

        //    const string sql = @"select MAX(Period) from [Operations].[LaFundingReportProvider]";

        //    return await connectionInfo.Connection.ExecuteScalarAsync<int>(
        //            sql: sql,
        //            transaction: connectionInfo.Transaction)
        //        .ConfigureAwait(false);
        //}
        public async Task<IReadOnlyCollection<FspInfo>> GetLAFspInfos(IReadOnlyCollection<int> ukprn, int startPeriod,
            int endPeriod, ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("ukprnLst", GetUkprnsTable(ukprn).AsTableValuedParameter("UkprnsUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<FspInfo>("sp_Operations_GetLAFspInfos", param, commandType: CommandType.StoredProcedure, commandTimeout: twoFourtySeconds);
            return rows.ToList();
        }
        public async Task<IReadOnlyCollection<UkprnInfo>> GetLAUkprnsForPeriod(int startPeriod,
            int endPeriod, ConnectionInfo connectionInfo)
        {
            var rows = await connectionInfo.Connection.QueryAsync<UkprnInfo>(
                    "sp_Operations_GetLAUkprnsForPeriod @startPeriod,@endPeriod",
                    param: new { startPeriod,endPeriod },
                    transaction: connectionInfo.Transaction)
                .ConfigureAwait(false);

            return rows.ToList();
        }

        public async Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetLADeliverablePaymentInfosForPoP(
            IReadOnlyCollection<int> ukprns,
            IReadOnlyCollection<string> fspCodes,
             int startPeriod,
             int endPeriod,
            ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("ukprnLst", GetUkprnsTable(ukprns).AsTableValuedParameter("UkprnsUDT"));
            param.Add("fspCodes", GetFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<DeliverablePaymentInfo>("sp_Operations_GetLADeliverablePaymentInfosForPoP", param, commandType: CommandType.StoredProcedure, commandTimeout: twoFourtySeconds);
            return rows.ToList();
        }

        public async Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetLADeliverablePaymentInfosForPoAForFinancialYear(
            IReadOnlyCollection<int> ukprns,
            IReadOnlyCollection<string> fspCodes,
            int startPeriod,
            int endPeriod,
            ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("ukprnLst", GetUkprnsTable(ukprns).AsTableValuedParameter("UkprnsUDT"));
            param.Add("fspCodes", GetFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<DeliverablePaymentInfo>("sp_Operations_GetLADeliverablePaymentInfosForPoAForFinancialYear", param, commandType: CommandType.StoredProcedure, commandTimeout: twoFourtySeconds);
            return rows.ToList();
        }

        public async Task<IReadOnlyCollection<DeliverablePaymentInfo>>
            GetLADeliverablePaymentInfosForPoAForALAPNLAP(
                IReadOnlyCollection<int> ukprns,
                IReadOnlyCollection<string> fspCodes,
                int startPeriod,
                int endPeriod,
                ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("ukprnLst", GetUkprnsTable(ukprns).AsTableValuedParameter("UkprnsUDT"));
            param.Add("fspCodes", GetFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<DeliverablePaymentInfo>("sp_Operations_GetLADeliverablePaymentInfosForPoAForALAPNLAP", param, commandType: CommandType.StoredProcedure, commandTimeout: twoFourtySeconds);
            return rows.ToList();
        }

        public async Task<IReadOnlyCollection<NetPaymentInfo>> GetLANetPaymentInfosForPayOnInstruction(
            IReadOnlyCollection<int> ukprns,
            IReadOnlyCollection<string> fspCodes,
            int startPeriod,
            int endPeriod,
            ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("ukprnLst", GetUkprnsTable(ukprns).AsTableValuedParameter("UkprnsUDT"));
            param.Add("fspCodes", GetFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<NetPaymentInfo>("sp_Operations_GetLANetPaymentInfosForPayOnInstruction", param, commandType: CommandType.StoredProcedure, commandTimeout: twoFourtySeconds);
            return rows.ToList();
        }
        private static DataTable GetUkprnsTable(IReadOnlyCollection<int> ukprns)
        {
            var ukprnDT = new DataTable();
            ukprnDT.Columns.Add("Ukprn");
            foreach (var ukprn in ukprns)
            {
                ukprnDT.Rows.Add(ukprn);
            }
            return ukprnDT;
        }
        private static DataTable GetFspCodesTable(IReadOnlyCollection<string> fspCodes)
        {
            var fspDT = new DataTable();
            fspDT.Columns.Add("FspCodes");
            foreach (var fsp in fspCodes)
            {
                fspDT.Rows.Add(fsp);
            }
            return fspDT;
        }
    }
}