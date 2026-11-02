namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    public interface IActualVolumeApplicator
    {
        void MutatePaymentScheduleWithActualVolume(
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentScheduleForAllocation,
            IReadOnlyCollection<DeliverablePayment> deliverablePayments,
            ContractAllocationActualsType allocationActuals);
    }
}