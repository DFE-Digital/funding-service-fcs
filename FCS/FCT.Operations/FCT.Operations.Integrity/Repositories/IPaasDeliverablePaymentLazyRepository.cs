namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using DTOs;

    public interface IPaasDeliverablePaymentLazyRepository
    {
        IReadOnlyCollection<DeliverablePaymentWithFsp> GetDeliverablePaymentsNotPaidExternally();
    }
}
