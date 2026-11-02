namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Transformers;

    public static class DocumentsDomainFundingTypeFundingPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingTypePeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new DocumentsDomainDbContext())
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