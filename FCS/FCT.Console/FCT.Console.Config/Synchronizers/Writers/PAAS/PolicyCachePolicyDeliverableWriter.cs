namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Synchronizers.PaaS.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Transformers;

    public class PolicyCachePolicyDeliverableWriter
    {
        public static void WriteToPaaSDatabase(IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                ConfigWriter<FundingStreamPeriodDeliverablesSheetType, PolicyDeliverable> writer =
                    new ConfigWriter<FundingStreamPeriodDeliverablesSheetType, PolicyDeliverable>(context,
                        context.PolicyDeliverables);

                UpdateCappingGroupForeignKey(context, rows);

                writer.Write(rows, PolicyDeliverableTransformer.TransformCollection, GetKeyForPolicyDeliverable, behaviour);

                context.SaveChanges();

                PolicyFundingStreamPeriodRepository.UpdateIsPrioritisedApportionment(context.Database.Connection);
            }
        }

        private static object[] GetKeyForPolicyDeliverable(PolicyDeliverable entity)
        {
            return new object[] {entity.DeliverableCode, entity.FundingStreamPeriod};
        }

        private static void UpdateCappingGroupForeignKey(PaymentManagementPolicyContext context,
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows)
        {
            var rowsWithDeliverableCappingGroup = rows.Where(r => !string.IsNullOrEmpty(r.DeliverableCappingGroup)).ToList();

            foreach (FundingStreamPeriodDeliverablesSheetType row in rowsWithDeliverableCappingGroup)
            {
                CappingGroup cappingGroup = context.CappingGroups
                    .SingleOrDefault(cg => (cg.FundingStreamPeriod == row.FundingStreamPeriodCode)
                                           && (cg.CappingGroupName == row.DeliverableCappingGroup));

                row.FundingStreamPeriodCappingGroupId = cappingGroup?.FundingStreamPeriodCappingGroupId;
            }
        }
    }
}