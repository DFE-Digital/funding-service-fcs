namespace FCT.Operations.FundingAllocationExtract.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public enum FundingAllocationExtractType
    {
        NotSet,
        Parked,
        Discarded
    }
    public class FundingAllocationExtractRepository : IFundingAllocationExtractRepository
    {
        public async Task<IReadOnlyCollection<ExtractRow>> GetExtract(FundingAllocationExtractType extractType, ConnectionInfo connectionInfo)
        {
            var extractTypeString = extractType.ToString();
            var rows = await connectionInfo.Connection.QueryAsync<ExtractRow>("sp_Operations_GetExtract @extractTypeString",
                    new { extractTypeString },
                    transaction: connectionInfo.Transaction)
                    .ConfigureAwait(false);

            return rows.ToList();
        }

    }
}
