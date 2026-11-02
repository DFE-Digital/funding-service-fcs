namespace PaymentManagement.Calculation.Repositories
{
    using System.Linq;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public class AllocationQueryRepository : IAllocationQueryRepository
    {
        public Option<int> GetPreviousVersion(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                var earlierVersions = context.Allocations.Where(a =>
                        a.AllocationNumber == allocationNumber && a.VersionNumber < versionNumber)
                    .Select(a => a.VersionNumber)
                    .ToList();

                return earlierVersions.Any() ? earlierVersions.Max().Some() : new Option<int>();
            }
        }

        public bool IsPayableFcrPublishedForAllocation(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.PublishedPayableFcrAllocations.Any(a => a.AllocationNumber == allocationNumber);
            }
        }
    }
}
