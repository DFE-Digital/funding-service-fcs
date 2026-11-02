namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public class AllocationRepository : IAllocationRepository
    {
        public int GetPreviousApprovedContractVersionNumberFromPaymentSchedule(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                IReadOnlyCollection<int> contractVersionNumbers = context.Allocations
                    .Where(a => a.AllocationNumber == allocationNumber && a.ContractVersionNumber < versionNumber)
                    .Select(a => a.ContractVersionNumber)
                    .ToList();

                if (!contractVersionNumbers.Any())
                {
                    throw new ArgumentException($"There are no previous allocations for {allocationNumber} and {versionNumber}");
                }

                return contractVersionNumbers.Max();
            }
        }

        public bool HasPreviousAllocationVersion(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.Allocations.Any(a => a.AllocationNumber == allocationNumber && a.ContractVersionNumber < versionNumber);
            }
        }

        public bool IsAllocationAlreadyPresentInStorage(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.Allocations.Any(a => a.AllocationNumber == allocationNumber && a.VersionNumber == versionNumber);
            }
        }

        public void AddOrUpdate(Allocation allocation, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                UpSertHelper<Allocation> upSertHelper = new UpSertHelper<Allocation>(
                    saveChanges: context.SaveChanges,
                    updateExisting: context.UpdateEntry);

                upSertHelper.AddOrUpdateEntity(
                    entityToAddOrUpdate: allocation,
                    getExisting: () => context.Allocations.Find(allocation.AllocationNumber, allocation.VersionNumber),
                    dbSet: context.Allocations);
            }
        }
    }
}
