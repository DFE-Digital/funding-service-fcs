namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Transformers;

    public class DocumentsDomainNlapFundingConfigWriter
    {
        public static void WriteToPaasDatabase(IEnumerable<NlapFundingConfigSheet> rows, WriterBehaviour behaviour)
        {
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                ConfigWriter<NlapFundingConfigSheet, NlapFundingConfig> writer =
                    new ConfigWriter<NlapFundingConfigSheet, NlapFundingConfig>(context, context.NlapFundingConfigs);

                writer.Write(rows, TypeTransformer.TransformCollection<NlapFundingConfigSheet, NlapFundingConfig>, GetKey, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKey(NlapFundingConfig entity) => new object[] { entity.Ukprn };
    }
}
