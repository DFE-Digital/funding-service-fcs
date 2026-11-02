namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System.Collections.Generic;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    public interface IDeliverablePaymentRepository
    {
        IReadOnlyCollection<DeliverablePayment> GetDeliverablePaymentsForAllocation(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);

        int? GetLatestVersion(string allocationNumber, ConnectionInfo connectionInfo);

        void AddOrUpdate(DeliverablePayment deliverablePayment, ConnectionInfo connectionInfo);

        IReadOnlyCollection<DeliverablePayment> CopyDeliverablePaymentsWithoutPlannedValueOnCertainDeliverableCodes(
            IReadOnlyCollection<DeliverablePayment> deliverablePayments,
            IReadOnlyCollection<int> deliverableCodesWherePlannedValueShouldBeRemoved);

        void AddOrUpdateDeliverablePaymentsForAllocation(IReadOnlyCollection<DeliverablePayment> deliverablePayments, string allocationNumber, int version,
            ConnectionInfo connectionInfo);

        void UpdateActualValuesAndVolumes(IReadOnlyCollection<DeliverablePayment> deliverablePayments, ConnectionInfo connectionInfo);

        IReadOnlyCollection<DeliverableActual> GetSummedActualsByDeliverableForAllocation(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);

        IReadOnlyCollection<DeliverablePeriodActualVolume> GetDeliverablePeriodActualVolumesForAllocation(
            string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);
    }
}
