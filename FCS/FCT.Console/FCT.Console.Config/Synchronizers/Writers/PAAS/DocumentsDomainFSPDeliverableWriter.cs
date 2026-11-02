namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Transformers;

    public class DocumentsDomainFSPDeliverableWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                ConfigWriter<FundingStreamPeriodDeliverablesSheetType, FSPDeliverable> writer =
                    new ConfigWriter<FundingStreamPeriodDeliverablesSheetType, FSPDeliverable>(context,
                        context.FSPDeliverables);

                writer.Write(rows,
                    TypeTransformer
                        .TransformCollection<FundingStreamPeriodDeliverablesSheetType, FSPDeliverable>,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(FSPDeliverable entity)
        {
            return new object[] { entity.DeliverableCode, entity.FundingStreamPeriodCode };
        }
    }
}