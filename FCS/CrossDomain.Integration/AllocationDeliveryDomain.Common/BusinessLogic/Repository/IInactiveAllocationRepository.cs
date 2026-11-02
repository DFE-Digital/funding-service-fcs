namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using CrossDomain.Integration.Entities.Data;
    using DataStore.Model;

    public interface IInactiveAllocationRepository
    {
        void AddOrUpdate(InactiveAllocation inactiveAllocation, ConnectionInfo connectionInfo);

        int SaveChanges();
    }
}