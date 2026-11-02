namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Transformers;

    public static class CdaExtractFspWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<CdaExtractFspSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            {
                ConfigWriter<CdaExtractFspSheetType, CdaReportFundingStreamPeriod> writer = new ConfigWriter<CdaExtractFspSheetType, CdaReportFundingStreamPeriod>(context, context.CdaReportFundingStreamPeriods);

                writer.Write(rows, TypeTransformer.TransformCollection<CdaExtractFspSheetType, CdaReportFundingStreamPeriod>,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(CdaReportFundingStreamPeriod entity)
        {
            return new object[] { entity.ExtractName, entity.FundingStreamPeriodCode };
        }
    }
}