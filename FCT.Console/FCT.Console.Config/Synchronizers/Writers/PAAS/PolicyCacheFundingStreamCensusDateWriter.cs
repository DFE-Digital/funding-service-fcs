namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Transformers;

    public static class PolicyCacheFundingStreamCensusDateWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<PaymentTimetablesSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                ConfigWriter<PaymentTimetablesSheetType, PolicyFundingStreamCensusDate> writer = new ConfigWriter<PaymentTimetablesSheetType, PolicyFundingStreamCensusDate>(context, context.PolicyFundingStreamCensusDates);

                writer.Write(rows, PaymentTimetableTransformer.TransformCollectionToPolicyFundingStreamCensusDates,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(PolicyFundingStreamCensusDate entity)
        {
            return new object[] {entity.FundingStreamPeriod, entity.CalendarYear, entity.CalendarPeriod};
        }
    }
}
