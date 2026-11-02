namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Transformers;

    public class PolicyCacheFundingStreamPeriodCappingGroupWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodCappingGroupSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                ConfigWriter<FundingStreamPeriodCappingGroupSheetType, CappingGroup> writer = new ConfigWriter<FundingStreamPeriodCappingGroupSheetType, CappingGroup>(context, context.CappingGroups);

                writer.Write(rows, TypeTransformer.TransformCollection<FundingStreamPeriodCappingGroupSheetType, CappingGroup>,
                    GetKeyForPolicyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicyFundingStreamPeriod(CappingGroup entity)
        {
            return new object[] { entity.FundingStreamPeriodCappingGroupId };
        }
    }
}
