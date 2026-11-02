namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Transformers;

    public class MonitoringDeliverablesFundingStreamPeriodDeliverableWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                ConfigWriter<FundingStreamPeriodDeliverablesSheetType, FundingStreamPeriodDeliverable> writer =
                    new ConfigWriter<FundingStreamPeriodDeliverablesSheetType, FundingStreamPeriodDeliverable>(context,
                        context.FundingStreamPeriodDeliverables);

                // this PaaS table only holds 'AllowActuals = true' data
                rows = rows.Where(r => r.AllowActuals);

                writer.Write(rows,
                    TypeTransformer
                        .TransformCollection<FundingStreamPeriodDeliverablesSheetType, FundingStreamPeriodDeliverable>,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(FundingStreamPeriodDeliverable entity)
        {
            return new object[] {entity.FundingStreamPeriodCode, entity.DeliverableCode};
        }
    }
}