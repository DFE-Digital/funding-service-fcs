namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Transformers;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class PerfMgmtClaimCollectionWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimCollectionsSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<ClaimCollectionsSheetType, ClaimCollection> writer =
                    new ConfigWriter<ClaimCollectionsSheetType, ClaimCollection>(context, context.ClaimCollections);

                writer.Write(rows, TypeTransformer.TransformCollection<ClaimCollectionsSheetType, ClaimCollection>,
                    GetKeyForClaimType, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForClaimType(ClaimCollection entity)
        {
            return new object[] { entity.ClaimCollectionCode };
        }
    }
}
