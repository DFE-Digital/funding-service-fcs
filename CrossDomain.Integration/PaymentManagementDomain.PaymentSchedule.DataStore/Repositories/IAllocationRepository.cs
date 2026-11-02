namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public interface IAllocationRepository
    {
        int GetPreviousApprovedContractVersionNumberFromPaymentSchedule(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);

        bool HasPreviousAllocationVersion(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);

        bool IsAllocationAlreadyPresentInStorage(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);

        void AddOrUpdate(Allocation allocation, ConnectionInfo connectionInfo);
    }
}
