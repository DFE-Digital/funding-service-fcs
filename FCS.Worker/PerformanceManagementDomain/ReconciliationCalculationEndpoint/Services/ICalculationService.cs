namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using System.Threading.Tasks;

    public interface ICalculationService
    {
        Task<FundingClaimReconciliation> Calculate(DebatchedFundingClaim debatchedFundingClaim, ConnectionInfo connectionInfo, decimal claimAdjustmentValue = 0, decimal? earningsBoostValue = 0);
    }
}