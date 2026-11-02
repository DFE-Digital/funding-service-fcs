namespace FCT.Operations.FundingAllocationExtract.Repositories
{
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface IFundingAllocationExtractRepository
    {
        Task<IReadOnlyCollection<ExtractRow>> GetExtract(FundingAllocationExtractType extractType, ConnectionInfo connectionInfo);
    }
}