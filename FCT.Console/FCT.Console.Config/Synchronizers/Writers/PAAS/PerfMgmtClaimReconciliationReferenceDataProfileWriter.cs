namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Transformers;

    public class PerfMgmtClaimReconciliationReferenceDataProfileWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimReconciliationReferenceDataProfileSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<ClaimReconciliationReferenceDataProfileSheetType, ClaimReconciliationReferenceDataProfile> writer =
                    new ConfigWriter<ClaimReconciliationReferenceDataProfileSheetType, ClaimReconciliationReferenceDataProfile>(context, context.ClaimReconciliationReferenceDataProfiles);

                writer.Write(rows, TypeTransformer.TransformCollection<ClaimReconciliationReferenceDataProfileSheetType, ClaimReconciliationReferenceDataProfile>,
                    GetKeyForClaimReconciliationReferenceDataProfile, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForClaimReconciliationReferenceDataProfile(ClaimReconciliationReferenceDataProfile entity)
        {
            return new object[] { entity.ClaimReconciliationDeliverableGroupCode, entity.Ukprn };
        }

    }
}
