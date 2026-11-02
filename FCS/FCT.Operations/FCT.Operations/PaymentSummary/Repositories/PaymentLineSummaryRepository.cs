namespace FCT.Operations.PaymentSummary.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Reflection;
    using System.IO;    
    using System.Data;
    

    public class PaymentLineSummaryRepository : IPaymentLineSummaryRepository
    {
       
        public async Task<IReadOnlyCollection<PaymentSummaryLine>> GetPaymentSummaryLines(ReportingPeriod reportingPeriod, ConnectionInfo connectionInfo)
        {
            var subnominalValues = await GetSubnominalValueInfromFromDb(reportingPeriod.Year, reportingPeriod.Month, reportingPeriod.Day, connectionInfo);

            var paymentLines =  subnominalValues.GroupBy(s => new {s.Ukprn, s.TradingName,s.AgencyPayment}).Select(grp =>
            {
                return new PaymentSummaryLine(
                    grp.Key.Ukprn, 
                    grp.Key.TradingName, 
                    grp.Key.AgencyPayment,
                    payments:grp.Select(subnominalValue => new FspPayment(subnominalValue.FundingStreamPeriodName,subnominalValue.Total,subnominalValue.AgencyPayment)).ToList());
            }).ToList();
           
            var fsps = paymentLines.SelectMany(pl => pl.Payments.Select(p => p.Fsp)).Distinct().ToList();
            
            paymentLines.ForEach(pl =>
            {
                var currentFsps = pl.Payments.Select(p => p.Fsp).ToList();
                var missingFsps= fsps.Where(fsp => !currentFsps.Contains(fsp)).ToList();
                missingFsps.ForEach(missingFsp => pl.Payments.Add(new FspPayment(missingFsp, 0)));
            });

            return paymentLines;
        }

        public async Task<IReadOnlyCollection<PaymentSummaryLine>> Get1619PaymentSummaryLines(ReportingPeriod reportingPeriod, ConnectionInfo connectionInfo)
        {
            var subnominalValues = await Get1619SubnominalValueInfromFromDb(reportingPeriod.Year, reportingPeriod.Month, reportingPeriod.Day, connectionInfo);

            var paymentLines = subnominalValues.GroupBy(s => new { s.Ukprn, s.ParentTradingName, s.ChildUkprn,s.ChildTradingName,s.Fsp,s.Total1619,s.AgencyPayment1619}).Select(grp =>
            {
                return new PaymentSummaryLine(
                    grp.Key.Ukprn,
                    grp.Key.ParentTradingName,
                    grp.Key.ChildUkprn,
                     grp.Key.ChildTradingName,
                     grp.Key.Total1619,
                    payments: grp.Select(subnominalValue => new FspPayment(subnominalValue.Fsp, subnominalValue.AgencyPayment1619, subnominalValue.Total1619, subnominalValue.RowNum)).ToList());
            }).ToList();

            var fsps = paymentLines.SelectMany(pl => pl.Payments.Select(p => p.Fsp)).Distinct().ToList();

            paymentLines.ForEach(pl =>
            {
                var currentFsps = pl.Payments.Select(p => p.Fsp).ToList();
                var missingFsps = fsps.Where(fsp => !currentFsps.Contains(fsp)).ToList();
                missingFsps.ForEach(missingFsp => pl.Payments.Add(new FspPayment(missingFsp, 0)));
            });

            return paymentLines;
        }

        private static DataTable getPaymentMethodTable(List<int> paymentMethods)
        {
            var paymentMethodDT = new DataTable();
            paymentMethodDT.Columns.Add("paymentMethod");
            foreach (var paymentMethod in paymentMethods)
            {
                paymentMethodDT.Rows.Add(paymentMethod);
            }
            return paymentMethodDT;
        }

        private static async Task<IReadOnlyCollection<SubnominalValueInfo>> GetSubnominalValueInfromFromDb(int year, int month,int day, ConnectionInfo connectionInfo)
        {
            List<int> PaymentMethods = GetPaymentInfo(day);           

            var param = new DynamicParameters();
            param.Add("PaymentMethods", getPaymentMethodTable(PaymentMethods).AsTableValuedParameter("PaymentMethodUDT"));
            param.Add("year", year);
            param.Add("month", month);          


            var subnominalInfos = await connectionInfo.Connection.QueryAsync<SubnominalValueInfo>(
                    "sp_Operation_GetSubnominalValueInfromFromDb", 
                    param,
                    commandType: CommandType.StoredProcedure,
                    transaction:connectionInfo.Transaction,
                    commandTimeout:(int)TimeSpan.FromMinutes(5).TotalSeconds)
                .ConfigureAwait(false);

            return subnominalInfos.ToList();
        }

        private static async Task<IReadOnlyCollection<SubnominalValueInfo>> Get1619SubnominalValueInfromFromDb(int year, int month, int day, ConnectionInfo connectionInfo)
        {

            var subnominalInfos = await connectionInfo.Connection.QueryAsync<SubnominalValueInfo>(
                                            "dbo.sp_Operation_Get1619SubnominalValueInfromFromDb @year,@month",
                                            param: new { year, month = month.ToString("00") },
                                            transaction: connectionInfo.Transaction,
                                            commandTimeout: (int)TimeSpan.FromMinutes(5).TotalSeconds)
                                        .ConfigureAwait(false);

            return subnominalInfos.ToList();
        }

     
        public static List<int> GetPaymentInfo(int day)
        {
            List<int> pMethod;
            if (day < 7)
            {
                pMethod = new List<int> { 2 };
            }
            else
            {
                pMethod = new List<int> { 1, 2, 3 };
            }
            return pMethod;
        }

        private class SubnominalValueInfo
        {
            public SubnominalValueInfo()
            { }
            public SubnominalValueInfo(decimal total, int ukprn, string agencypayment, string tradingName, string fundingStreamPeriodName)
            {
                Total = total;
                Ukprn = ukprn;
                FundingStreamPeriodName = fundingStreamPeriodName;
                TradingName = tradingName;
                AgencyPayment = agencypayment;
            }

            public SubnominalValueInfo(decimal total1619, int ukprn, int childukprn, decimal agencypayment1619, string parenttradingName, string childtradingName, string fsp, int rowNum)
            {
                Total1619 = total1619;
                Ukprn = ukprn;
                ChildUkprn = childukprn;
                Fsp = fsp;
                ParentTradingName = parenttradingName;
                ChildTradingName = childtradingName;
                AgencyPayment1619 = agencypayment1619;
                RowNum = rowNum;
            }
            public decimal Total { get; }
            public int Ukprn { get; }
            public string FundingStreamPeriodName { get; }
            public string TradingName { get; }
            public string AgencyPayment { get; }

            public decimal Total1619 { get; }
            public int ParentUkprn { get; }
            public int ChildUkprn { get; }
            public string Fsp { get; }
            public string ParentTradingName { get; }

            public string ChildTradingName { get; }
            public decimal AgencyPayment1619 { get; }
            public int RowNum { get; }


        }
    }
}