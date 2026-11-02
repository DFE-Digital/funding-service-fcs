namespace PaymentManagement.Calculation.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public interface IFundingClaimReconciliationService
    {
        bool IsPayableFcrPublishedForAllocation(string allocationNumber, ConnectionInfo connectionInfo);

        Allocation CreatePaymentScheduleFromPreviousVersion(allocationType allocation, ConnectionInfo connectionInfo);
    }
}