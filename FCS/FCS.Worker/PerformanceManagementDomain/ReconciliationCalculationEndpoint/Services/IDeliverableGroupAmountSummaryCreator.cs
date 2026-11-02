namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    public interface IDeliverableGroupAmountSummaryCreator
    {
        Task<AmountSummary> CalculateAndCreateAmountSummary(
            decimal parentDeliverablePlannedValue,
            decimal totalPlannedValueForGroup,
            decimal? totalClaimValueForGroup,
            bool shouldCapToProfile,
            string delGroupCode,
            int ukprn,
            ConnectionInfo connectionInfo);
    }
}