namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Transformers;

    public class PolicyCachePolicySubnominalWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<SubnominalsSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                ConfigWriter<SubnominalsSheetType, PolicySubnominal> writer = new ConfigWriter<SubnominalsSheetType, PolicySubnominal>(context, context.PolicySubnominals);

                writer.Write(rows, SubnominalTransformer.TransformCollection,
                    GetKeyForPolicySubnominal, behaviour);

                context.SaveChanges();
            }
        }

        public static void ClearPaasDatabaseTable()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                List<PolicySubnominal> entitiesToDelete = context.PolicySubnominals.ToList();
                entitiesToDelete.ForEach(e => context.PolicySubnominals.Remove(e));

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForPolicySubnominal(PolicySubnominal entity)
        {
            return new object[] { entity.SubnominalCode, entity.PaymentType };
        }
    }
}
