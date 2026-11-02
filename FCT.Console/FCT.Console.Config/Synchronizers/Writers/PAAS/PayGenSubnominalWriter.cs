namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Transformers;

    public class PayGenSubnominalWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<SubnominalsSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                ConfigWriter<SubnominalsSheetType, Subnominal> writer =
                    new ConfigWriter<SubnominalsSheetType, Subnominal>(context, context.Subnominals);

                writer.Write(rows, TypeTransformer.TransformCollection<SubnominalsSheetType, Subnominal>,
                    GetKeyForSubnominal, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForSubnominal(Subnominal entity)
        {
            return new object[] { entity.Code };
        }
    }
}
