namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Transformers;

    public static class PayGenFundingStreamPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod> writer = new ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod>(context, context.FundingStreamPeriods);

                writer.Write(rows, TypeTransformer.TransformCollection<FundingStreamPeriodSheetType, FundingStreamPeriod>,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(FundingStreamPeriod entity)
        {
            return new object[] {entity.Code};
        }
    }
}
