namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class PaymentInstructionAuditRepository : IPaymentInstructionAuditRepository
    {
        public void CreatePaymentInstructionAudits(IEnumerable<PaymentInstructionAudit> paymentInstructionAudits, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                context.PaymentInstructionAudits.AddRange(paymentInstructionAudits);
                context.SaveChanges();
            }
        }
    }
}