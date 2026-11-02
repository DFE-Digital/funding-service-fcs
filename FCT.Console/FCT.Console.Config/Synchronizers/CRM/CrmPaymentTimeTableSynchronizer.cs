namespace FCT.Console.Config.Synchronizers.CRM
{
    using Excel;
    using FCT.Console.Config.ExcelTypes;
    using Readers;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System.Collections.Generic;
    using System.Linq;
    using Writers;
    using Writers.CRM;

    public class CrmPaymentTimeTableSynchronizer :PaymentTimetablesSheetReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<PaymentTimetablesSheetType> paymentTimeTableSheetRows = ReadConfig(worksheetReader);

            paymentTimeTableSheetRows = FilterSheetRows(paymentTimeTableSheetRows);

            new CrmPaymentTimeTableWriter().WriteToCrmDatabase(paymentTimeTableSheetRows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            new CrmPaymentTimeTableWriter().WriteToCrmDatabase(ReadConfig(worksheetReader), WriterBehaviour.Delete);
        }

        private static IReadOnlyCollection<PaymentTimetablesSheetType> FilterSheetRows(
            IReadOnlyCollection<PaymentTimetablesSheetType> rows)
        {
            IReadOnlyCollection<string> validFundingStreamsForPayGen = GetValidFundingStreamPeriodsForPayGen();

            return rows.Where(sheetRow => validFundingStreamsForPayGen.Contains(sheetRow.FundingStreamPeriodCode)).ToList();
        }

        private static IReadOnlyCollection<string> GetValidFundingStreamPeriodsForPayGen()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                return
                    context.PolicyFundingStreamPeriods.Where(fsp => fsp.PaymentMethod != PaymentMethod.NoPay)
                        .Select(fsp => fsp.FundingStreamPeriod).ToList();
            }
        }

    }
}
