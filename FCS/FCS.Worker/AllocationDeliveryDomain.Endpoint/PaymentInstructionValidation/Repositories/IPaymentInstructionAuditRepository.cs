namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPaymentInstructionAuditRepository
    {
        void CreatePaymentInstructionAudits(IEnumerable<PaymentInstructionAudit> paymentInstructionAudits, ConnectionInfo connectionInfo);
    }
}