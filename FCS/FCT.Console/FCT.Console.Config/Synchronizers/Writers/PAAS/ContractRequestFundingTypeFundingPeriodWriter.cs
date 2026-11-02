
namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Transformers;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;

    public static class ContractRequestFundingTypeFundingPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingTypePeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractRequestDbContext())
            {
                ConfigWriter<FundingTypePeriodSheetType, FundingTypeFundingPeriod> writer = new ConfigWriter<FundingTypePeriodSheetType, FundingTypeFundingPeriod>(context, context.FundingTypeFundingPeriods);

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
