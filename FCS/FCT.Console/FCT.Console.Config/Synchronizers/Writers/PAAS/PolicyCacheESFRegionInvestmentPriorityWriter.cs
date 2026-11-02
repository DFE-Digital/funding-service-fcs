namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Transformers;

    public class PolicyCacheESFRegionInvestmentPriorityWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<ESFRegionInvestmentPrioritySheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                ConfigWriter<ESFRegionInvestmentPrioritySheetType, ESFRegionInvestmentPriority> writer = new ConfigWriter<ESFRegionInvestmentPrioritySheetType, ESFRegionInvestmentPriority>(context, context.ESFRegionInvestmentPriorities);

                writer.Write(rows, ESFRegionInvestmentPriorityTransformer.TransformCollection,
                    GetKeyForFspPolicySubnominal, behaviour);

                context.SaveChanges();
            }
        }

        private static object[] GetKeyForFspPolicySubnominal(ESFRegionInvestmentPriority entity)
        {
            return new object[] { entity.RegionType, entity.InvestmentPriority };
        }
    }
}
