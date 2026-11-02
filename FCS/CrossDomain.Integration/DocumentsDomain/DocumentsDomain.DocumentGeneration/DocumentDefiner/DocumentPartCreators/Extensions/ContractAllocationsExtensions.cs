namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using PaymentManagementDomain.PolicyCache.DataStore.Repositories;

    public static class ContractAllocationsExtensions
    {
        public static ILookup<string, int> GetTopLevelParentDeliverableCodes(
            this IEnumerable<contractAllocationsContractAllocation> contractAllocations,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository)
        {
            return contractAllocations
                .Select(a => a.fundingStreamPeriodCode)
                .Distinct()
                .SelectMany(fsp =>
                    payCalcPolicyQueryRepository.GetFundingStreamPeriodDeliverablesNonConnectionInfo(fsp)
                        .Where(d => d.ParentDeliverableCode == null).OrderBy(pd => pd.DeliverableCode)).ToList()
                .ToLookup(d => d.FundingStreamPeriod, d => d.DeliverableCode);
        }
    }
}
