namespace FundingAllocation.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using Dto;

    public static class FundingAllocationEnumerableExtensions
    {
        public static IReadOnlyCollection<FundingAllocation> WhereInTheseFundingIds(
            this IEnumerable<FundingAllocation> fundingAllocations, IReadOnlyCollection<string> fundingIds)
        {
            return fundingAllocations.Where(fa => fundingIds.Contains(fa.FundingId)).ToList();
        }

        public static IReadOnlyCollection<FundingAllocationLine> GetFundingAllocationLines(
            this IEnumerable<FundingAllocation> fundingAllocations)
        {
            return fundingAllocations.SelectMany(fa =>
                fa.ProviderFundingAllocations.SelectMany(pfa => pfa.ProviderFunding.FundingAllocationLines)).ToList();
        }

        public static IReadOnlyCollection<FundingAllocationValidationInput> ToValidationInputs(
            this IEnumerable<FundingAllocation> fundingAllocations)
        {
            return fundingAllocations.Select(fa => fa.ToValidationInput()).ToList();
        }

        public static bool IsAnyFundingAllocationEnvelopeGreater(
            this IEnumerable<FundingAllocation> fundingAllocations, IEnumerable<FundingAllocation> otherFundingAllocations, Func<FundingAllocationLine, decimal> getEnvelope)
        {
            return fundingAllocations.Any(fa =>
            {
                var otherFundingAllocation = otherFundingAllocations.Single(otherFa =>
                    otherFa.FundingAllocationName == fa.FundingAllocationName);

                var otherLines = otherFundingAllocation.GetFundingAllocationLines();

                return fa.GetFundingAllocationLines().Any(line =>
                {
                    var otherLine = otherLines.SingleOrDefault(otherLine =>
                        otherLine.FundingLineCode == line.FundingLineCode &&
                        otherLine.ProviderFundingId == line.ProviderFundingId);

                    var otherLineEnvelope = otherLine != null ? getEnvelope(otherLine) : 0;

                    return getEnvelope(line) > 0 && getEnvelope(line) > otherLineEnvelope;
                });
            });
        }
    }
}
