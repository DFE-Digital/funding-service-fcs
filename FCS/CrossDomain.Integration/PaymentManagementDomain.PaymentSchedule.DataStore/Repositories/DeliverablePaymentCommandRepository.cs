namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    public class DeliverablePaymentCommandRepository : IDeliverablePaymentCommandRepository
    {
        public async Task AddDeliverablePeriodIfNotPresent(string allocationNumber, int version, int deliverableCode,
            string period, ConnectionInfo connectionInfo, PeriodTypeCode periodTypeCode = PeriodTypeCode.CM)
        {
            const int uniqueConstraint = 2627;
            try
            {
                using (var context =
                    new PaymentSchedulePolicyContext(connectionInfo.Connection, connectionInfo.Transaction))
                {
                    context.DeliverablePayments.Add(new DeliverablePayment
                    {
                        AllocationNumber = allocationNumber,
                        VersionNumber = version,
                        DeliverableCode = deliverableCode,
                        Period = period,
                        PeriodTypeCode = periodTypeCode
                    });

                    await context.SaveChangesAsync();
                }
            }
            catch (DbUpdateException ex) when (ex.InnerException?.InnerException is SqlException &&
                                               ((SqlException)ex.InnerException.InnerException).Number == uniqueConstraint)
            {
                // nothing to see here, this needs to be idempotent
            }
        }
    }
}
