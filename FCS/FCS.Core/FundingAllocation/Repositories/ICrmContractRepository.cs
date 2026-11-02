namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public interface ICrmContractRepository
    {
        Task<IReadOnlyCollection<CrmContractStatusInfo>> GetContractStatusInfosForUkprn(int ukprn, string fundingTypeCode);

        Task<IReadOnlyCollection<CrmAllocationInfo>> GetAllocationInfosForContractEntityId(string crmEntityId);
    }
}