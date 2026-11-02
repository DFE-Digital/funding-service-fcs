namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Services
{
    using System.Collections.Generic;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;

    public interface IPaymentScheduleService
    {
        void CreateMissingDeliverablesAndTheirPeriods(
            IReadOnlyCollection<DeliverableInfo> existingDeliverables,
            AllocationInfo allocationInfo,
            string fspCode,
            IReadOnlyCollection<DeliverablePeriodYear> missingDeliverablePeriodYears);

        void UpdateExistingDeliverablesAndTheirPeriods(
            IReadOnlyCollection<DeliverableInfo> existingDeliverables,
            AllocationInfo allocationInfo,
            string fspCode,
            IReadOnlyCollection<DeliverablePeriodYear> existingDeliverablePeriodYears,
            IReadOnlyCollection<DeliverablePeriodYear> paymentScheduleDeliverablePeriodYears);

    }
}