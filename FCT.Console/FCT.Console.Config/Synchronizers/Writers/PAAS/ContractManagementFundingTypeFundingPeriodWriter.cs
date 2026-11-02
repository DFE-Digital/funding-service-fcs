namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ExcelTypes;
    using Transformers;
    using ContractManagement.DataStore.Model;

    public static class ContractManagementFundingTypeFundingPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingTypePeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            {
                ConfigWriter<FundingTypePeriodSheetType, FundingTypeFundingPeriod> writer = new ConfigWriter<FundingTypePeriodSheetType, FundingTypeFundingPeriod>(context, context.FundingTypeFundingPeriodItems);

                writer.Write(rows, TypeTransformer.TransformCollection<FundingTypePeriodSheetType, FundingTypeFundingPeriod>,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(FundingTypeFundingPeriod entity)
        {
            return new object[] { entity.FundingTypeCode, entity.FundingPeriodName };
        }
    }
}
