namespace FundingAllocation.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using Dto;
    using Microsoft.EntityFrameworkCore;
    using DataStore.Model;

    public class ContractRepository : IContractRepository
    {
        private readonly FundingAllocationContext _context;

        public ContractRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<IReadOnlyCollection<FundingAllocationInfo>> GetFundingAllocationInfosInContractControl(string contractNumber, int contractVersionNumber)
        {
            var createdRelationship = RelationshipToFundingAllocationEnum.Created.ToString();

            var fundingAllocationIds = await (from c in _context.Contracts
                join fa in _context.FundingAllocations on c.Id equals fa.ContractId
                where c.ContractNumber == contractNumber &&
                      c.ContractVersionNumber == contractVersionNumber &&
                      fa.CrmEntityId != null &&
                      c.RelationshipToFundingAllocation == createdRelationship
                select new {fa.FundingId, fa.CrmEntityId}).ToListAsync();

            return fundingAllocationIds.Select(fa => new FundingAllocationInfo(fa.FundingId, fa.CrmEntityId?.ToString() ?? string.Empty)).ToList();
        }

        public async Task DeleteContractIfOrphaned(string contractNumber, int contractVersionNumber, int contractSubversionNumber)
        {
            await _context.Database.GetDbConnection().ExecuteAsync("FundingAllocation.DeleteContractIfOrphaned @contractNumber,@contractVersionNumber,@contractSubversionNumber",
                   transaction: _context.CurrentTransaction,
                   param: new { contractNumber, contractVersionNumber, contractSubversionNumber });
        }

        public async Task<int> CreateContractWithQueuedRelationshipOrReturnExistingId(string contractNumber, int contractVersionNumber, int contractSubVersionNumber)
        {
            var queued = RelationshipToFundingAllocationEnum.Queued.ToString();
            const bool isCreatedInCrm = true;

           
            var contractId = await _context.Database.GetDbConnection().ExecuteScalarAsync("FundingAllocation.CreateContractWithQueuedRelationshipOrReturnExistingId @contractNumber,@contractVersionNumber,@contractSubVersionNumber,@isCreatedInCrm,@queued",
                             new { contractNumber, contractVersionNumber, contractSubVersionNumber, isCreatedInCrm, queued },
                              transaction: _context.CurrentTransaction);

            return Convert.ToInt32(contractId);
        }
    }
}
