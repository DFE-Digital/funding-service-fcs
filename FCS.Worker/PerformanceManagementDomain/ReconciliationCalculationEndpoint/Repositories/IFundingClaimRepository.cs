namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using static FundingClaimRepository;
    using DtoFundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;

    public interface IFundingClaimRepository
    {
        Task<DtoFundingClaim> GetFundingClaimByNaturalKey(FundingClaimNaturalKey naturalKey, ConnectionInfo connectionInfo);
    }
}