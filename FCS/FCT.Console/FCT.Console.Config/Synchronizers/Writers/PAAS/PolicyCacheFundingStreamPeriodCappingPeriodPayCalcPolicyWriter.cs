namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Transformers;

    public class PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter
    {
        public static void WriteToPaasDatabase(IEnumerable<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                var writer = new ConfigWriter<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType, FundingStreamPeriodCappingPeriodPayCalcPolicy>
                    (context, context.FundingStreamPeriodCappingPeriodPayCalcPolicies);
                
                writer.Write(rows, TypeTransformer
                        .TransformCollection<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType, FundingStreamPeriodCappingPeriodPayCalcPolicy>, GetKey, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKey(FundingStreamPeriodCappingPeriodPayCalcPolicy entity) => 
            new object[] { entity.FundingStreamPeriodCode, entity.CalcPolicyVersion, entity.CappingPeriod };
    }
}