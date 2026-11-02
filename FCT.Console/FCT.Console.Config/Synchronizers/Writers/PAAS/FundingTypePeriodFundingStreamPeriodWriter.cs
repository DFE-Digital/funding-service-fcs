namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Transformers;

    public class FundingTypePeriodFundingStreamPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingTypePeriodFundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            {
                ConfigWriter<FundingTypePeriodFundingStreamPeriodSheetType, FundingTypePeriodFundingStreamPeriod> writer =
                    new ConfigWriter<FundingTypePeriodFundingStreamPeriodSheetType, FundingTypePeriodFundingStreamPeriod>(context,
                        context.FundingTypePeriodFundingStreamPeriodItems);

                writer.Write(rows,
                    TypeTransformer.TransformCollection<FundingTypePeriodFundingStreamPeriodSheetType, FundingTypePeriodFundingStreamPeriod>,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(FundingTypePeriodFundingStreamPeriod entity)
        {
            return new object[] { entity.FundingTypeCode, entity.FundingPeriodCode, entity.FundingStreamCode };
        }
    }
}