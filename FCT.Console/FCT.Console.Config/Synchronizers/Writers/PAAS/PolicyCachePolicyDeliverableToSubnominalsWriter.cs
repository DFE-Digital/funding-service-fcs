namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class PolicyCachePolicyDeliverableToSubnominalsWriter
    {
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows, WriterBehaviour behaviour)
        {
            for (int start = 0; start < rows.Count(); start++)
            {
                using (var context = new PaymentManagementPolicyContext())
                {
                    ConfigWriter<FundingStreamPeriodDeliverablesSheetType, PolicyDeliverableToSubnominals> writer = new ConfigWriter<FundingStreamPeriodDeliverablesSheetType, PolicyDeliverableToSubnominals>(context, context.PolicyDeliverableToSubnominals);

                    var singleRows = rows.Skip(start).Take(1);
                    writer.Write(singleRows, TransformSubnominals,
                        GetKeyForPolicyDeliverableToSubnominals, behaviour);

                    context.SaveChanges();
                }
            }
        }

        private static object[] GetKeyForPolicyDeliverableToSubnominals(PolicyDeliverableToSubnominals entity)
        {
            return new object[] { entity.DeliverableCode, entity.FundingStreamPeriod, entity.SubnominalCode, entity.PaymentType };
        }

        private static IEnumerable<PolicyDeliverableToSubnominals> TransformSubnominals(IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows)
        {
            IList<PolicyDeliverableToSubnominals> subs = new List<PolicyDeliverableToSubnominals>();

            foreach(FundingStreamPeriodDeliverablesSheetType row in rows)
            {
                if(!string.IsNullOrWhiteSpace(row.PaymentSubnominalCodeProfile))
                {
                    PolicyDeliverableToSubnominals newSub = new PolicyDeliverableToSubnominals
                    {
                        DeliverableCode = row.DeliverableCode,
                        FundingStreamPeriod = row.FundingStreamPeriodCode,
                        SubnominalCode = int.Parse(row.PaymentSubnominalCodeProfile),
                        PaymentType = PaymentType.Profile
                    };
                    subs.Add(newSub);
                }

                if (!string.IsNullOrWhiteSpace(row.PaymentSubnominalCodeReconciliation))
                {
                    PolicyDeliverableToSubnominals newSub = new PolicyDeliverableToSubnominals
                    {
                        DeliverableCode = row.DeliverableCode,
                        FundingStreamPeriod = row.FundingStreamPeriodCode,
                        SubnominalCode = int.Parse(row.PaymentSubnominalCodeReconciliation),
                        PaymentType = PaymentType.Reconciliation
                    };
                    subs.Add(newSub);
                }

                if (!string.IsNullOrWhiteSpace(row.PaymentSubnominalCodeCapping))
                {
                    PolicyDeliverableToSubnominals newSub = new PolicyDeliverableToSubnominals
                    {
                        DeliverableCode = row.DeliverableCode,
                        FundingStreamPeriod = row.FundingStreamPeriodCode,
                        SubnominalCode = int.Parse(row.PaymentSubnominalCodeCapping),
                        PaymentType = PaymentType.Capping
                    };
                    subs.Add(newSub);
                }
            }
            return subs;
        }
    }
}