namespace FundingAllocation.Endpoints.DocumentGenerationComplete.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;

    public class ContractRepository : IContractRepository
    {
        private readonly FundingAllocationContext _context;

        public ContractRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<IReadOnlyCollection<string>> GetFundingAllocationIdsForContract(
            string contractNumber,
            int version,
            int subVersion)
        {
            var createdRelationship = RelationshipToFundingAllocationEnum.Created.ToString();

            return await _context.Contracts.AsNoTracking()
                .Include(c => c.FundingAllocations)
                .Where(c => c.ContractNumber == contractNumber &&
                            c.ContractVersionNumber == version &&
                            c.ContractSubVersionNumber == subVersion &&
                            c.RelationshipToFundingAllocation == createdRelationship)
                .SelectMany(c => c.FundingAllocations.Select(fa => fa.FundingId)).ToArrayAsync();
        }

        public async Task SetContractCreatedInCrmFlag(string contractNumber,
            int version,
            int subVersion)
        {
            var createdRelationship = RelationshipToFundingAllocationEnum.Created.ToString();

            await _context.Contracts.Where(c => c.ContractNumber == contractNumber &&
                                          c.ContractVersionNumber == version &&
                                          c.ContractSubVersionNumber == subVersion &&
                                          c.RelationshipToFundingAllocation == createdRelationship)
                .ForEachAsync(c =>
            {
                c.IsCreatedInCrm = true;
            });

            await _context.SaveChangesAsync();
        }
    }
}
