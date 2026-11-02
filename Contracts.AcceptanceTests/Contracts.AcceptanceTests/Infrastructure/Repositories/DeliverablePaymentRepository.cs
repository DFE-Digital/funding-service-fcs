namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Extensions;
    using PaymentManagementDomain.PaymentSchedule.DataStore;

    public static class DeliverablePaymentRepository
    {
        public static void DeleteDeliverablePaymentsForAllVersionsOfAllocation(string allocationNumber, int deliverableCode)
        {
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.RemoveWhere(dp =>
                    dp.AllocationNumber == allocationNumber && dp.DeliverableCode == deliverableCode);
                context.SaveChanges();
            }
        }

        public static int GetRowCount(string allocationNumber, int versionNumber, int deliverableCode)
        {
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                return context.DeliverablePayments.Count(dp =>
                    dp.AllocationNumber == allocationNumber && dp.VersionNumber == versionNumber && dp.DeliverableCode == deliverableCode);
            }
        }

        public static void DeleteDeliverablePaymentsForAllocations(IReadOnlyCollection<string> allocationNumbers)
        {
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.RemoveWhere(dl =>
                allocationNumbers.Contains(dl.AllocationNumber));
                context.SaveChanges();
            }
        }
    }
}
