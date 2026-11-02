namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Data;
    using PaymentSchedule.DataStore.Model;

    public interface IPaymentScheduleService
    {
        void SavePaymentSchedule(
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentScheduleForAllocation,
            IReadOnlyCollection<DeliverablePayment> deliverablePayments,
            ProcessingMode processingMode,
            DateTime? allocationStartDate,
            DateTime? allocationEndDate,
            ConnectionInfo connectionInfo);
    }
}