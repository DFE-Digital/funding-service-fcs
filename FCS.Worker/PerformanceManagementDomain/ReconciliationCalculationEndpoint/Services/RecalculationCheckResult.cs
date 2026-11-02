namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using CrmRepositories;

    public class RecalculationCheckResult
    {
        public RecalculationCheckResult(bool isCalculationRequired, FundingClaimReconciliationInformation fundingClaimReconciliationInformation)
        {
            IsCalculationRequired = isCalculationRequired;
            FundingClaimReconciliationInformation = fundingClaimReconciliationInformation;
        }

        public bool IsCalculationRequired { get; }

        public FundingClaimReconciliationInformation FundingClaimReconciliationInformation { get; }
    }
}