namespace FundingAllocation.Endpoints.DocumentGenerationComplete.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using System.Threading.Tasks;

    public interface ICrmFundingAllocationCommandRepository
    {
        Task UpdateFundingAllocation(string fundingId, string contractNumber, int contractVersionNumber,
            sfa_FundingAllocationServiceResponse sfaFundingAllocationServiceResponse);
    }
}