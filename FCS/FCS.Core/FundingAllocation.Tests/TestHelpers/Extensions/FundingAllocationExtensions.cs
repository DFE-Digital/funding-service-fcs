namespace FundingAllocation.Tests.TestHelpers.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using FundingAllocation.Extensions;

    public static class FundingAllocationExtensions
    {
        public static ProviderFundingAllocation AddProvider(this FundingAllocation fundingAllocation, string providerFundingId)
        {
            var providerAllocation =
                new ProviderFundingAllocation(providerFundingId, string.Empty)
                {
                    ProviderFunding = new ProviderFunding(providerFundingId,0, string.Empty, string.Empty)
                };

            if (fundingAllocation.ProviderFundingAllocations.IsEmpty())
            {
                List<ProviderFundingAllocation> providerFundingAllocations = new List<ProviderFundingAllocation>
                {
                    providerAllocation
                };

                typeof(FundingAllocation).GetProperty("ProviderFundingAllocations")
                    .SetValue(fundingAllocation, providerFundingAllocations, null);
            }
            else
            {
                fundingAllocation.ProviderFundingAllocations.Add(providerAllocation);
            }

            return providerAllocation;
        }

        public static FundingAllocation WithProviderWithLineCodeAndPlannedValue(this FundingAllocation fundingAllocation, string providerFundingId, string lineCode, decimal periodPlannedValue)
        {
            var providerAllocation =
                new ProviderFundingAllocation(providerFundingId, string.Empty)
                {
                    ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
                };
            providerAllocation.AddFundingAllocationLine(lineCode).AddPeriods(new List<(int period, decimal plannedVale)>{(202101, periodPlannedValue)});

            if (fundingAllocation.ProviderFundingAllocations.IsEmpty())
            {
                List<ProviderFundingAllocation> providerFundingAllocations = new List<ProviderFundingAllocation>
                {
                    providerAllocation
                };

                typeof(FundingAllocation).GetProperty("ProviderFundingAllocations")
                    .SetValue(fundingAllocation, providerFundingAllocations, null);
            }
            else
            {
                fundingAllocation.ProviderFundingAllocations.Add(providerAllocation);
            }

            return fundingAllocation;
        }

        public static FundingAllocationLine AddFundingAllocationLine(this ProviderFundingAllocation providerFundingAllocation, string fundingLineCode)
        {
            var fundingAllocationLine =
                new FundingAllocationLine(providerFundingAllocation.ProviderFundingId, fundingLineCode);

            if (providerFundingAllocation.ProviderFunding.FundingAllocationLines.IsEmpty())
            {
                List<FundingAllocationLine> fundingAllocationLines = new List<FundingAllocationLine>
                {
                    fundingAllocationLine
                };

                providerFundingAllocation.ProviderFunding = new ProviderFunding(providerFundingAllocation.ProviderFundingId, 0, string.Empty, string.Empty);

                typeof(ProviderFunding).GetProperty("FundingAllocationLines")
                    .SetValue(providerFundingAllocation.ProviderFunding, fundingAllocationLines, null);
            }
            else
            {
                providerFundingAllocation.ProviderFunding.FundingAllocationLines.Add(fundingAllocationLine);
            }
            
            return fundingAllocationLine;
        }

        public static void AddPeriods(this FundingAllocationLine fundingAllocationLine, List<(int period, decimal plannedVale)> periods)
        {
            var fundingAllocationProfilePeriods = periods.Select(p =>
                new FundingAllocationProfilePeriod(fundingAllocationLine.ProviderFundingId,
                    fundingAllocationLine.FundingLineCode, p.period, p.plannedVale)).ToList();
                
            if (fundingAllocationLine.FundingAllocationProfilePeriods.IsEmpty())
            {
                typeof(FundingAllocationLine).GetProperty("FundingAllocationProfilePeriods")
                    .SetValue(fundingAllocationLine, fundingAllocationProfilePeriods, null);
            }
            else
            {
                fundingAllocationLine.FundingAllocationProfilePeriods.AddRange(fundingAllocationProfilePeriods);
            }
        }
    }
}
