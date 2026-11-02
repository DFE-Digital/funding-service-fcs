namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Transformers;

    public class PerfMgmtClaimReconciliationPublicationExceptionWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimReconciliationPublicationExceptionSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            using (var tr = context.Database.BeginTransaction())
            {
                ClearClaimReconciliationPublicationExceptionTable(context);

                var writer = new ConfigWriter<ClaimReconciliationPublicationExceptionSheetType, ClaimReconciliationPublicationException>(
                    context, context.ClaimReconciliationPublicationExceptions);

                writer.Write(
                    rows,
                    TypeTransformer.TransformCollection<ClaimReconciliationPublicationExceptionSheetType, ClaimReconciliationPublicationException>,
                    GetKey,
                    behaviour);

                context.SaveChanges();
                tr.Commit();
            }
        }

        private static object[] GetKey(ClaimReconciliationPublicationException entity)
        {
            return new object[] { entity.ClaimReconciliationAllocationGroupCode, entity.Ukprn };
        }

        private static void ClearClaimReconciliationPublicationExceptionTable(IPerformanceManagementDbContext context)
        {
            const string deleteSqlCommand = "DELETE FROM [PerformanceManagement].[ClaimReconciliationPublicationException]";

            context.ExecuteSqlCommand(deleteSqlCommand);
        }
    }
}
