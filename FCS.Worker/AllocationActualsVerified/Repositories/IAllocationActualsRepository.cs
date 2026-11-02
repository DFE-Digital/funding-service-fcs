namespace PaymentManagementDomain.AllocationActualsVerified.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    public interface IAllocationActualsRepository
    {
        void WriteAllocationActualsToCrm(ContractAllocationActualsType allocationActual);
    }
}