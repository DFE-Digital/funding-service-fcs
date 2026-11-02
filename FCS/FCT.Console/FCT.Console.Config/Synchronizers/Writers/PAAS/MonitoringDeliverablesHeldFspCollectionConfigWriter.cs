namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Transformers;

    public class MonitoringDeliverablesHeldFspCollectionConfigWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ActualsCollectionReturnsSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                ConfigWriter<ActualsCollectionReturnsSheetType, HeldFspCollectionConfig> writer = new ConfigWriter<ActualsCollectionReturnsSheetType, HeldFspCollectionConfig>(context, context.HeldFspCollectionConfigs);

                writer.Write(rows, TypeTransformer.TransformCollection<ActualsCollectionReturnsSheetType, HeldFspCollectionConfig>,
                    GetKeyForHeldFspCollectionConfig, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForHeldFspCollectionConfig(HeldFspCollectionConfig entity)
        {
            return new object[] { entity.MultipleCollectionGroupId, entity.FundingStreamPeriodCode, entity.CollectionType };
        }
    }
}