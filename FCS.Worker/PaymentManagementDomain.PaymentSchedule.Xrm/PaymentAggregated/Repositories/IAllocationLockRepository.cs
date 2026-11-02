namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationLockRepository
    {
        bool CanAquireLockOnAllocation(string allocationNumber, int version, ConnectionInfo connectionInfo);
    }
}