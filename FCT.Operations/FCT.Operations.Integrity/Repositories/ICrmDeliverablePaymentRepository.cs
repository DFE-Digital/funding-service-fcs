namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using DTOs;

    public interface ICrmDeliverablePaymentRepository
    {
        IReadOnlyCollection<CrmDeliverablePaymentData> GetByAllocationVersionDeliverableCodeAndVersion(
            string allocationNumber,
            int version,
            int deliverableCode,
            string period);

        IReadOnlyCollection<CrmDeliverablePaymentData> GetByAllocationNumberAndVersion(string allocationNumber, int version);

        IReadOnlyCollection<CrmDeliverablePaymentData> GetApprovedRowsByFsps(IReadOnlyCollection<string> activeFsps);
    }
}
