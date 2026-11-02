namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Synchronizers.PaaS.Repositories;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Transformers;

    public static class PayGenPaymentTimetableWriter
    {
        public static void WriteToPaaSDatabase(IReadOnlyCollection<PaymentTimetablesSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                if (behaviour == WriterBehaviour.AddOrUpdate)
                {
                    PaymentTimetableRepository.RemoveUnprocessedRows(context);
                    rows = FilterSheetRowsForAddOrUpdate(rows);
                }

                ConfigWriter<PaymentTimetablesSheetType, PaymentTimetable> writer = new ConfigWriter<PaymentTimetablesSheetType, PaymentTimetable>(context, context.PaymentTimetables);

                writer.Write(rows, PaymentTimetableTransformer.TransformToPaymentTimetableCollection,
                    GetKeyForPolicyFundingStreamPeriod, timetable => timetable.Status == "NotStarted", behaviour);

                context.SaveChanges();
            }
        }

        private static IReadOnlyCollection<PaymentTimetablesSheetType> FilterSheetRowsForAddOrUpdate(
            IReadOnlyCollection<PaymentTimetablesSheetType> rows)
        {
            IReadOnlyCollection<string> validFundingStreamsForPayGen = GetValidFundingStreamPeriodsForPayGen();

            return rows.Where(sheetRow => validFundingStreamsForPayGen.Contains(sheetRow.FundingStreamPeriodCode)).ToList();
        } 


        private static object[] GetKeyForPolicyFundingStreamPeriod(PaymentTimetable entity)
        {
            return new object[] { entity.FundingStreamPeriodCode, entity.CalendarPeriod };
        }

        private static IReadOnlyCollection<string> GetValidFundingStreamPeriodsForPayGen()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                return
                    context.FundingStreamPeriods.Where(fsp => fsp.ShouldGeneratePayments)
                        .Select(fsp => fsp.Code).ToList();
            }
        } 
    }
}
