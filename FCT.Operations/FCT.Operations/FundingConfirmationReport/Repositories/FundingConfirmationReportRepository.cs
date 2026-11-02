namespace FCT.Operations.FundingConfirmationReport.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using System.Data;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingConfirmationReportRepository : IFundingConfirmationReportRepository
    {
        const int twofourtySeconds = 240;
        //public async Task<int> GetLatestPeriodFromConfig(ConnectionInfo connectionInfo)
        //{
        //    const string sql = @"select MAX(Period) from [Operations].[FundingReportProvider]";

        //    return await connectionInfo.Connection.ExecuteScalarAsync<int>(
        //            sql: sql,
        //            transaction: connectionInfo.Transaction)
        //        .ConfigureAwait(false);
        //}

        public async Task<IReadOnlyCollection<FspInfo>> GetFspInfos(IReadOnlyCollection<int> ukprn, int startPeriod,
            int endPeriod, ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("ukprnLst", GetUkprnsTable(ukprn).AsTableValuedParameter("UkprnsUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<FspInfo>("sp_OperationS_GetFspInfos", param, commandType: CommandType.StoredProcedure, commandTimeout: twofourtySeconds);
            return rows.ToList();
        }

        //public async Task<IReadOnlyCollection<string>> GetFundingPeriodsForPeriod(int period,
        //    ConnectionInfo connectionInfo)
        //{
        //    const string sql = @"SELECT Distinct [FundingPeriod]
        //                         FROM [Operations].[FundingReportProvider] p
        //                         where p.Period = @period";

        //    var rows = await connectionInfo.Connection.QueryAsync<string>(
        //            sql: sql,
        //            param: new { period },
        //            transaction: connectionInfo.Transaction)
        //        .ConfigureAwait(false);

        //    return rows.ToList();
        //}

        public async Task<IReadOnlyCollection<UkprnInfo>> GetUkprnsForPeriod(int startPeriod,
            int endPeriod, ConnectionInfo connectionInfo)
        {
          
            var rows = await connectionInfo.Connection.QueryAsync<UkprnInfo>("sp_Operations_GetUkprnsForPeriod @startPeriod,@endPeriod",
                    param: new { startPeriod, endPeriod },transaction: connectionInfo.Transaction, commandTimeout: twofourtySeconds);
            return rows.ToList();
        }

        public async Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetDeliverablePaymentInfosForPoP(
            IReadOnlyCollection<string> fspCodes,
              int startPeriod,
              int endPeriod,
            ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("fspCodes", GetFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<DeliverablePaymentInfo>("sp_Operations_GetDeliverablePaymentInfosForPoP", param, commandType: CommandType.StoredProcedure, commandTimeout: twofourtySeconds);
            return rows.ToList();
        }

        public async Task<IReadOnlyCollection<DeliverablePaymentInfo>> GetDeliverablePaymentInfosForPoAForAcademicYear(
            IReadOnlyCollection<string> fspCodes,
              int startPeriod,
              int endPeriod,
            ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("fspCodes", GetFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<DeliverablePaymentInfo>("sp_Operations_GetDeliverablePaymentInfosForPoAForAcademicYear", param, commandType: CommandType.StoredProcedure, commandTimeout: twofourtySeconds);
            return rows.ToList();
        }

        public async Task<IReadOnlyCollection<DeliverablePaymentInfo>>
            GetDeliverablePaymentInfosForPoAForNonAcademicYear(
                IReadOnlyCollection<string> fspCodes,
                int startPeriod,
                int endPeriod,
                ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("fspCodes", GetFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<DeliverablePaymentInfo>("sp_Operations_GetDeliverablePaymentInfosForPoAForNonAcademicYear", param, commandType: CommandType.StoredProcedure, commandTimeout: twofourtySeconds);
            return rows.ToList();
        }

        public async Task<IReadOnlyCollection<NetPaymentInfo>> GetNetPaymentInfosForPayOnInstruction(
            IReadOnlyCollection<string> fspCodes,
            int startPeriod,
            int endPeriod,
            ConnectionInfo connectionInfo)
        {
            var param = new DynamicParameters();
            param.Add("fspCodes", GetFspCodesTable(fspCodes).AsTableValuedParameter("FspCodesUDT"));
            param.Add("startPeriod", startPeriod);
            param.Add("endPeriod", endPeriod);
            var rows = await connectionInfo.Connection.QueryAsync<NetPaymentInfo>("sp_Operations_GetNetPaymentInfosForPayOnInstruction", param, commandType: CommandType.StoredProcedure, commandTimeout: twofourtySeconds);
            return rows.ToList();
        }

        private static DataTable GetFspCodesTable(IReadOnlyCollection<string> fspCodes)
        {
            DataTable fspDT = new DataTable();
            fspDT.Columns.Add("FspCodes");
            foreach (var fsp in fspCodes)
            {
                fspDT.Rows.Add(fsp);
            }
            return fspDT;
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

        //private static DataTable getFundingPeriodTable(IReadOnlyCollection<string> fundingPeriods)
        //{
        //    var fPeriodDT = new DataTable();
        //    fPeriodDT.Columns.Add("FundingPeriods");
        //    foreach (var fsp in fundingPeriods)
        //    {
        //        fPeriodDT.Rows.Add(fsp);
        //    }
        //    return fPeriodDT;
        //}
    }
}