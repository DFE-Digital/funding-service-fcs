namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using CrossDomain.Integration.Entities.Data;

    public interface IPreviousPaymentScheduleCopier
    {
        void CopyPreviousReplacedValuesOntoPaySchedule(string allocationNumber,
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation currentAllocation, ConnectionInfo connectionInfo);
    }
}