namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Transformers;

    public class PerfMgmtFundingStreamPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod> writer =
                    new ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod>(context, context.FundingStreamPeriods);

                writer.Write(rows, PerfMgmtFundingStreamPeriodTransformer.TransformCollection,
                    GetKeyForFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForFundingStreamPeriod(FundingStreamPeriod entity)
        {
            return new object[] { entity.FundingStreamPeriodCode };
        }
    }
}