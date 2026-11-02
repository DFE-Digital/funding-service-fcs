namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Transformers;

    public static class CdaExtractWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<CdaExtractSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            using (var tr = context.Database.BeginTransaction())
            {
                ClearCdaReportFundingStreamPeriodTable(context);

                ConfigWriter<CdaExtractSheetType, CdaExtract> writer = new ConfigWriter<CdaExtractSheetType, CdaExtract>(context, context.CdaExtracts);

                writer.Write(rows, TypeTransformer.TransformCollection<CdaExtractSheetType, CdaExtract>,
                    GetKeyForCdaExtract, behaviour);

                context.SaveChanges();
                tr.Commit();
            }
        }

        private static object[] GetKeyForCdaExtract(CdaExtract entity)
        {
            return new object[] { entity.ExtractName };
        }

        private static void ClearCdaReportFundingStreamPeriodTable(IContractManagementDbContext context)
        {
            const string deleteSqlCommand = "DELETE FROM [ContractManagement].[CdaExtract]";

            context.ExecuteSql(deleteSqlCommand);
        }
    }
}