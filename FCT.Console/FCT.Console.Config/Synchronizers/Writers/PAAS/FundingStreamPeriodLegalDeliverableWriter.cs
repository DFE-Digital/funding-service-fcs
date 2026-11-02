namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Transformers;

    public static class FundingStreamPeriodLegalDeliverableWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            using (var tr = context.Database.BeginTransaction())
            {
                ClearFundingStreamPeriodLegalDeliverableTable(context);

                ConfigWriter<FundingStreamPeriodDeliverablesSheetType, FundingStreamPeriodLegalDeliverable> writer =
                    new ConfigWriter<FundingStreamPeriodDeliverablesSheetType, FundingStreamPeriodLegalDeliverable>(context, context.FundingStreamPeriodLegalDeliverables);

                writer.Write(rows, TypeTransformer.TransformCollection<FundingStreamPeriodDeliverablesSheetType, FundingStreamPeriodLegalDeliverable>, GetKeyForFundingStreamPeriodLegalDeliverable, behaviour);

                context.SaveChanges();
                tr.Commit();
            }
        }

        private static object[] GetKeyForFundingStreamPeriodLegalDeliverable(FundingStreamPeriodLegalDeliverable model)
        {
            return new object[]
            {
                model.FundingStreamPeriodCode,
                model.DeliverableCode
            };
        }

        private static void ClearFundingStreamPeriodLegalDeliverableTable(IContractManagementDbContext context)
        {
            const string deleteSqlCommand = "DELETE FROM [ContractManagement].[FundingStreamPeriodLegalDeliverable]";

            context.ExecuteSql(deleteSqlCommand);
        }
    }
}
