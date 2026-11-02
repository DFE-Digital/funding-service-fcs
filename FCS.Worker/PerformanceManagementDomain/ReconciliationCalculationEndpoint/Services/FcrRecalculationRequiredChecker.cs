namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using CrmRepositories;
    using DTOs;

    public class FcrRecalculationRequiredChecker : IFcrRecalculationRequiredChecker
    {
        private readonly ICrmFundingClaimReconciliationRepository _crmFcrRepository;

        public FcrRecalculationRequiredChecker(ICrmFundingClaimReconciliationRepository crmFcrRepository)
        {
            _crmFcrRepository = crmFcrRepository;
        }

        public RecalculationCheckResult CheckIfRecalculationRequired(IReadOnlyCollection<AllocationInfo> allocationsPlannedValue, string allocationNumber, decimal newPlannedValue)
        {
            decimal? existingPlannedValue = allocationsPlannedValue.SingleOrDefault(a => a.AllocationNumber == allocationNumber)?.PlannedValue;

            FundingClaimReconciliationInformation fundingClaimReconciliationInformation = null;

            if (newPlannedValue != existingPlannedValue)
            {
                IReadOnlyCollection<FundingClaimReconciliationInformation> draftFundingClaimKeys = _crmFcrRepository.GetFundingClaimReconciliationInfos(allocationNumber)
                    .Where(k => k.IsDraft)
                    .ToList();

                fundingClaimReconciliationInformation = draftFundingClaimKeys.SingleOrDefault();
            }

            return new RecalculationCheckResult(fundingClaimReconciliationInformation != null, fundingClaimReconciliationInformation);
        }
    }
}