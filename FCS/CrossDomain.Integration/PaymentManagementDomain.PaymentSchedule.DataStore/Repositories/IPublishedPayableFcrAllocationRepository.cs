namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;

    public interface IPublishedPayableFcrAllocationRepository
    {
        bool IsPayableFcrPublishedForAllocation(string allocationNumber, ConnectionInfo connectionInfo);

        void Add(string allocationNumber, ConnectionInfo connectionInfo);
    }
}
