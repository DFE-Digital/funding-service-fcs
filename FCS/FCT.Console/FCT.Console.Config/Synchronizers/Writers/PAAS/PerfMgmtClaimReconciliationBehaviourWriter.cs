namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Transformers;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    public static class PerfMgmtClaimReconciliationBehaviourWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimReconciliationBehaviourSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<ClaimReconciliationBehaviourSheetType, ClaimReconciliationBehaviour> writer =
                    new ConfigWriter<ClaimReconciliationBehaviourSheetType, ClaimReconciliationBehaviour>(context, context.ClaimReconciliationBehaviours);

                writer.Write(rows, TypeTransformer.TransformCollection<ClaimReconciliationBehaviourSheetType, ClaimReconciliationBehaviour>,
                    GetKeyForClaimReconciliationBehaviourType, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForClaimReconciliationBehaviourType(ClaimReconciliationBehaviour entity)
        {
            return new object[] { entity.ClaimCollectionCode, entity.ClaimReconciliationAllocationGroupCode };
        }
    }
}
