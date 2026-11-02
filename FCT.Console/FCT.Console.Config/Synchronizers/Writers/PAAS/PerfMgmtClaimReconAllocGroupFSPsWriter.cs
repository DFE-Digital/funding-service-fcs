namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Transformers;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class PerfMgmtClaimReconAllocGroupFSPsWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimReconAllocGroupFSPSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<ClaimReconAllocGroupFSPSheetType, ClaimReconciliationAllocationGroupFsp> writer =
                    new ConfigWriter<ClaimReconAllocGroupFSPSheetType, ClaimReconciliationAllocationGroupFsp>(context, context.ClaimReconciliationAllocationGroupFsps);

                writer.Write(rows, TypeTransformer.TransformCollection<ClaimReconAllocGroupFSPSheetType, ClaimReconciliationAllocationGroupFsp>,
                    GetKeyForClaimReconAllocGroupFSPs, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForClaimReconAllocGroupFSPs(ClaimReconciliationAllocationGroupFsp entity)
        {
            return new object[] { entity.FspCode };
        }
    }
}
