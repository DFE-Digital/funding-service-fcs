namespace SFA.FCT.Operations.Integrity.DTOs
{
    using System.Collections.Generic;

    public class ChangeTrackedDeliverablePayments
    {
        public ChangeTrackedDeliverablePayments(IReadOnlyCollection<DeliverablePaymentKey> deliverablePaymentKeys, long currentVersion)
        {
            DeliverablePaymentKeys = deliverablePaymentKeys;
            CurrentVersion = currentVersion;
        }

        public IReadOnlyCollection<DeliverablePaymentKey> DeliverablePaymentKeys { get; }

        public long CurrentVersion { get; }
    }
}
