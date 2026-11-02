namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Transformers;

    public class PerfMgmtClaimReconciliationDelGroupWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimReconciliationDelGroupsSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<ClaimReconciliationDelGroupsSheetType, ClaimReconciliationDeliverableGroup> writer =
                    new ConfigWriter<ClaimReconciliationDelGroupsSheetType, ClaimReconciliationDeliverableGroup>(context, context.ClaimReconciliationDeliverableGroups);

                writer.Write(rows, TypeTransformer.TransformCollection<ClaimReconciliationDelGroupsSheetType, ClaimReconciliationDeliverableGroup>,
                    GetKeyForClaimReconciliationDeliverableGroup, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForClaimReconciliationDeliverableGroup(ClaimReconciliationDeliverableGroup entity)
        {
            return new object[] { entity.ClaimReconciliationDeliverableGroupCode };
        }
    }
}
