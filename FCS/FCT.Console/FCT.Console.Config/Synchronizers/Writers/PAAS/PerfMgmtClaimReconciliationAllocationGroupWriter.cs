namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Transformers;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    public static class PerfMgmtClaimReconciliationAllocationGroupWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimReconciliationAllocationGroupSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<ClaimReconciliationAllocationGroupSheetType, ClaimReconciliationAllocationGroup> writer =
                    new ConfigWriter<ClaimReconciliationAllocationGroupSheetType, ClaimReconciliationAllocationGroup>(context, context.ClaimReconciliationAllocationGroups);

                writer.Write(rows, TypeTransformer.TransformCollection<ClaimReconciliationAllocationGroupSheetType, ClaimReconciliationAllocationGroup>,
                    GetKeyForClaimReconciliationAllocationGroupType, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForClaimReconciliationAllocationGroupType(ClaimReconciliationAllocationGroup entity)
        {
            return new object[] { entity.ClaimReconciliationAllocationGroupCode };
        }
    }
}
