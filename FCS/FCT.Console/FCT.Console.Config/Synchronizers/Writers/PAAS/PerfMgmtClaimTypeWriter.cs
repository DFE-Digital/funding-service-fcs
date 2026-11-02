namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Transformers;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    public static class PerfMgmtClaimTypeWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ClaimTypeSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<ClaimTypeSheetType, ClaimType> writer =
                    new ConfigWriter<ClaimTypeSheetType, ClaimType>(context, context.ClaimTypes);

                writer.Write(rows, TypeTransformer.TransformCollection<ClaimTypeSheetType, ClaimType>,
                    GetKeyForClaimType, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForClaimType(ClaimType entity)
        {
            return new object[] { entity.ClaimTypeCode };
        }
    }
}
