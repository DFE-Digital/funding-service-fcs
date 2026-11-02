namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Transformers;

    public class PerfMgmtFspDeliverableClaimWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<FundingStreamPeriodDeliverablesSheetType, FspDeliverableClaim> writer =
                    new ConfigWriter<FundingStreamPeriodDeliverablesSheetType, FspDeliverableClaim>(context, context.FspDeliverableClaims);

                writer.Write(rows, FspDeliverableClaimTransformer.TransformCollection,
                    GetKeyForFspDeliverableClaim, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForFspDeliverableClaim(FspDeliverableClaim entity)
        {
            return new object[] { entity.FspCode, entity.DeliverableCode };
        }
    }
}