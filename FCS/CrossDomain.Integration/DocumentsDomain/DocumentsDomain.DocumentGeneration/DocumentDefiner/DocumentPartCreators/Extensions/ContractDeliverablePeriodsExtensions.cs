namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;

    public static class ContractDeliverablePeriodsExtensions
    {
        public static decimal GetTotalValue(
            this IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods,
            Func<contractDeliverablePeriodsTypeContractDeliverablePeriod, bool> periodFilter)
        {
            return deliverablePeriods
                .Where(periodFilter)
                .Sum(cdp => cdp.plannedValue);
        }
    }
}
