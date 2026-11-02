namespace FundingAllocation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class ExtendedContractAllocationsExtensions
    {
        public static (DateTime startDate, DateTime endDate) GetEarliestStartDateAndLatestEndDate(
            this IReadOnlyCollection<ExtendedContractAllocation> allocations)
        {
            var earliestStartDate = allocations.Select(a => a.startDate).Min();
            
            // in this domain allocations always have an end date
            var latestEndDate = allocations.Select(a => a.endDate.Value).Max();

            return (earliestStartDate, latestEndDate);
        }
    }
}
