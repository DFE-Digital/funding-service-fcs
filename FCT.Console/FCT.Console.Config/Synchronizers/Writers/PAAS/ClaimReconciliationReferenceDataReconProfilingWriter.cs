namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Transformers;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class ClaimReconciliationReferenceDataReconProfilingWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimReconciliationReferenceDataReconProfilingSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            using (var tr = context.Database.BeginTransaction())
            {
                ClearClaimReconciliationReferenceDataReconProfilingTable(context);

                var writer = new ConfigWriter<ClaimReconciliationReferenceDataReconProfilingSheetType, ClaimReconciliationReferenceDataReconProfiling>(
                    context, context.ClaimReconciliationReferenceDataReconProfilings);

                writer.Write(
                    rows,
                    TypeTransformer.TransformCollection<ClaimReconciliationReferenceDataReconProfilingSheetType, ClaimReconciliationReferenceDataReconProfiling>,
                    GetKey,
                    behaviour);

                context.SaveChanges();
                tr.Commit();
            }
        }

        private static object[] GetKey(ClaimReconciliationReferenceDataReconProfiling entity)
        {
            return new object[] { entity.FundingPeriod, entity.Ukprn };
        }

        private static void ClearClaimReconciliationReferenceDataReconProfilingTable(IPerformanceManagementDbContext context)
        {
            const string deleteSqlCommand = "DELETE FROM [PerformanceManagement].[ClaimReconciliationReferenceDataReconProfiling]";

            context.ExecuteSqlCommand(deleteSqlCommand);
        }
    }
}