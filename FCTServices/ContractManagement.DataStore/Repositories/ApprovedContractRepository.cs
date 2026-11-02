namespace ContractManagement.DataStore.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ApprovedContractRepository : IApprovedContractRepository
    {
        public bool HasOutstandingPayments(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                var foundContract = context.ApprovedContracts
                    .Where(aca => aca.ContractNumber == contractNumber &&
                                  aca.ContractVersionNumber == contractVersionNumber &&
                                  aca.ContractSubVersionNumber == contractSubVersionNumber)
                    .Include(aca => aca.ApprovedContractAllocations)
                    .First();

                return foundContract.ApprovedContractAllocations.Any(aca => aca.HasOutstandingPayments.HasValue && aca.HasOutstandingPayments.Value);
            }
        }

        public FundingTypeFundingPeriod GetFundingTypeFundingPeriodForContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber,
            ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                return context.ApprovedContracts.Where(
                    ac =>
                        ac.ContractNumber == contractNumber && ac.ContractVersionNumber == contractVersionNumber &&
                        ac.ContractSubVersionNumber == contractSubVersionNumber)
                    .Select(ac => ac.FundingTypeFundingPeriod)
                    .Single();
            }
        }

        public ApprovedContract GetContractForAllocationNumber(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                return context.ApprovedContracts.Include(c => c.ApprovedContractAllocations)
                    .OrderByDescending(contract => contract.ContractVersionNumber)
                    .First(ac => ac.ApprovedContractAllocations.Any(aca => aca.ContractAllocationNumber == allocationNumber));
            }
        }
    }
}
