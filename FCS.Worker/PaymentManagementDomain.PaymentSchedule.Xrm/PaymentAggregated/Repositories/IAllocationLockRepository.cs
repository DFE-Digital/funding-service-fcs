namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    extern alias IntegrationEntities;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationLockRepository
    {
        bool CanAquireLockOnAllocation(string allocationNumber, int version, ConnectionInfo connectionInfo);
    }
}