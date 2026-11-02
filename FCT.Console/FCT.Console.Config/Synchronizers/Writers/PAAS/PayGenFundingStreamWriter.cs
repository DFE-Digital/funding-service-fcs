namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using MoreLinq;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Transformers;

    public static class PayGenFundingStreamWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                ConfigWriter<FundingStreamSheetType, FundingStream> writer =
                    new ConfigWriter<FundingStreamSheetType, FundingStream>(context, context.FundingStreams);

                writer.Write(rows, TypeTransformer.TransformCollection<FundingStreamSheetType, FundingStream>,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(FundingStream entity)
        {
            return new object[] { entity.Code };
        }
    }
}
