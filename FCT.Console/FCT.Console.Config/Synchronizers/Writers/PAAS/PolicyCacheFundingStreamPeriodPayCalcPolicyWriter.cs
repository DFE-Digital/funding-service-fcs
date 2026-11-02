namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Transformers;

    public class PolicyCacheFundingStreamPeriodPayCalcPolicyWriter
    {
        public static void WriteToPaasDatabase(IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                var writer = new ConfigWriter<FundingStreamPeriodPayCalcPolicySheetType, FundingStreamPeriodPayCalcPolicy>(context, context.FundingStreamPeriodPayCalcPolicies);

                writer.Write(rows, PolicyCacheFundingStreamPeriodPayCalcPolicyTransformer.TransformCollection, GetKey, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKey(FundingStreamPeriodPayCalcPolicy entity) => new object[] { entity.FundingStreamPeriodCode, entity.CalcPolicyVersion };
    }
}
