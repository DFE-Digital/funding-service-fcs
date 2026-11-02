namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Data.Common;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.EntityFrameworkCore.Infrastructure;
    using FundingAllocation.DataStore.Model;

    public class ContractNumberQueryRepository : IContractNumberQueryRepository
    {
        private readonly FundingAllocationContext _context;

        public ContractNumberQueryRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<int> GetNextContractNumberForFundingType(string fundingType)
        {
            return await _context.Database.GetDbConnection().ExecuteScalarAsync<int>($"SELECT NEXT VALUE FOR [ContractManagement].[Contract_{fundingType}_seq] ",
                transaction: ((IInfrastructure<DbTransaction>)_context.Database.CurrentTransaction)?.Instance);
        }

        public async Task<int> GetNextMasterContractNumber()
        {
            return await _context.Database.GetDbConnection().ExecuteScalarAsync<int>($"SELECT NEXT VALUE FOR [ContractManagement].[Master_ESFA_seq]",
                transaction: ((IInfrastructure<DbTransaction>)_context.Database.CurrentTransaction)?.Instance);
        }

        public int GetNextAllocationNumber(string fundingStreamCode)
        {
            string sequenceName = GetSequenceName(SequenceType.Allocation, fundingStreamCode);
            return _context.Database.GetDbConnection().ExecuteScalar<int>($"SELECT NEXT VALUE FOR [ContractManagement].{sequenceName}",
                transaction: ((IInfrastructure<DbTransaction>)_context.Database.CurrentTransaction)?.Instance);
        }

        public string GetSequenceName(SequenceType _sequenceType, string fundingStreamCode)
        {
            return $@"{_sequenceType}_{fundingStreamCode
                .Replace("+", "_plus_")
                .Replace("-", "_hyphen_")
                .Replace(" ", string.Empty)}_seq";
        }
    }
}
