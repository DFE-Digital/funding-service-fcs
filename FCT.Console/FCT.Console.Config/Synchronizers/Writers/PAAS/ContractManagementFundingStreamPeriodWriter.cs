namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Transformers;

    public class ContractManagementFundingStreamPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new ContractManagementDbContext())
            {
                ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod> writer = new ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod>(context, context.FundingStreamPeriods);

                writer.Write(rows, TypeTransformer.TransformCollection<FundingStreamPeriodSheetType, FundingStreamPeriod>,
                    GetKeyForFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForFundingStreamPeriod(FundingStreamPeriod entity)
        {
            return new object[] { entity.FundingStreamPeriodCode };
        }
    }
}