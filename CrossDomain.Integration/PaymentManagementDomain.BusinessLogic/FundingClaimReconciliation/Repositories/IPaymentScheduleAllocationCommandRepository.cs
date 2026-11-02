namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Repositories
{
    using System;
    using CrossDomain.Integration.Entities.Data;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public interface IPaymentScheduleAllocationCommandRepository
    {
        void UpdateDeliverablePaymentsForAllocation(PaymentSchedule.Allocation allocation, DateTime allocationStartDate, DateTime allocationEndDate,
            ConnectionInfo connectionInfo);
    }
}
