namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;

    public interface IFundingClaimEnrichmentService
    {
        Task Enrich(FundingClaim fundingClaim, ConnectionInfo connectionInfo);
    }
}