namespace FundingAllocation.Endpoints.UpdateFundingAllocation
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public interface ICrmUpdateFundingAllocationRepository
    {
        Task ReturnToScheduling(string crmFundingAllocationEntityId, sfa_FundingAllocationServiceResponse serviceResponse);
    }
}