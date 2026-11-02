namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using ContractManagement.DataStore;

    public static class ApprovedContractRepository
    {
        public static IReadOnlyCollection<string> GetAllocationNumbersForUkprn(int ukprn)
        {
            using (var context = new ContractManagementDbContext())
            {
                var approvedAllocationNumbers = context.ApprovedContracts.AsNoTracking()
                    .Include(c => c.ApprovedContractAllocations)
                    .Where(c => c.Ukprn == ukprn)
                    .SelectMany(c => c.ApprovedContractAllocations.Select(a => a.ContractAllocationNumber))
                    .ToList();

                return approvedAllocationNumbers;
            }
        }

        public static void ClearApprovedContractsForUkprn(int ukprn)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.ApprovedContracts
                    .Where(c => c.Ukprn == ukprn)
                    .ToList()
                    .ForEach(c => context.ApprovedContracts.Remove(c));

                context.SaveChanges();
            }
        }

        public static void ClearApprovedContractsForContractNumber(string contractNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.ApprovedContracts
                    .Where(c => c.ContractNumber == contractNumber)
                    .ToList()
                    .ForEach(c => context.ApprovedContracts.Remove(c));

                context.SaveChanges();
            }
        }
    }
}
