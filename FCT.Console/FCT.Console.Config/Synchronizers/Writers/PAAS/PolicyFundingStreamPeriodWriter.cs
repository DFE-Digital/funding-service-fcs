namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Transformers;

    public static class PolicyFundingStreamPeriodWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                ConfigWriter<FundingStreamPeriodSheetType, PolicyFundingStreamPeriod> writer =  new ConfigWriter<FundingStreamPeriodSheetType, PolicyFundingStreamPeriod>(context, context.PolicyFundingStreamPeriods);

                writer.Write(rows, PolicyFundingStreamPeriodTransformer.TransformCollection,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);
               
                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(PolicyFundingStreamPeriod entity)
        {
            return new object[] {entity.FundingStreamPeriod};
        }
    }
}
