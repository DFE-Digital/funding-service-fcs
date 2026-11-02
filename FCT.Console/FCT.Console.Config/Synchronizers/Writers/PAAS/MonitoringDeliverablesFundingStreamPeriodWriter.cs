namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Transformers;

    public class MonitoringDeliverablesFundingStreamPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod> writer = new ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod>(context, context.FundingStreamPeriods);

                writer.Write(rows, MonitoringDeliverablesFundingStreamPeriodTransformer.TransformCollection,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(FundingStreamPeriod entity)
        {
            return new object[] { entity.Code };
        }
    }
}
