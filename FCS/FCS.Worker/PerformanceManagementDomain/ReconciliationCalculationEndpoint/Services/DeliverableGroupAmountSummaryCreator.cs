namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System.Threading.Tasks;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    public class DeliverableGroupAmountSummaryCreator : IDeliverableGroupAmountSummaryCreator
    {
        private readonly IClaimReferenceProfileRepository _claimReferenceProfileRepository;

        public DeliverableGroupAmountSummaryCreator(IClaimReferenceProfileRepository claimReferenceProfileRepository)
        {
            _claimReferenceProfileRepository = claimReferenceProfileRepository;
        }

        public async Task<AmountSummary> CalculateAndCreateAmountSummary(
            decimal parentDeliverablePlannedValue,
            decimal totalPlannedValueForGroup,
            decimal? totalClaimValueForGroup,
            bool shouldCapToProfile,
            string delGroupCode,
            int ukprn,
            ConnectionInfo connectionInfo)
        {

            decimal? cappedClaimValue = totalClaimValueForGroup;
            decimal? plannedValue = parentDeliverablePlannedValue == 0m ? totalPlannedValueForGroup : parentDeliverablePlannedValue;

            if (shouldCapToProfile)
            {
                if (await _claimReferenceProfileRepository.IsProfileFromReferenceData(delGroupCode, connectionInfo).ConfigureAwait(continueOnCapturedContext: false))
                {
                    decimal profileValue = await _claimReferenceProfileRepository.GetPlannedValue(delGroupCode, ukprn, connectionInfo).ConfigureAwait(continueOnCapturedContext: false) ?? 0;

                    if (totalClaimValueForGroup > profileValue)
                    {
                        cappedClaimValue = profileValue;
                    }

                    if (DeliverableGroupHasNoLegalDeliverables(delGroupCode))
                    {
                        plannedValue = totalPlannedValueForGroup;
                    }
                }
                else if (totalClaimValueForGroup > plannedValue)
                {
                    cappedClaimValue = plannedValue;
                }
            }

            return new AmountSummary
            {
                CappedClaimedValue = cappedClaimValue,
                ClaimedValue = totalClaimValueForGroup,
                PlannedValue = plannedValue
            };
        }

        private static bool DeliverableGroupHasNoLegalDeliverables(string delGroupCode)
        {
            // deliberate technical debt - should be removed along with profile reference code
            // after 16/17 funding claims
            return delGroupCode != "AEBTO-CL1617_PF";
        }
    }
}