namespace PaymentManagement.Calculation.Repositories
{
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationQueryRepository
    {
        Option<int> GetPreviousVersion(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);

        bool IsPayableFcrPublishedForAllocation(string allocationNumber, ConnectionInfo connectionInfo);
    }
}