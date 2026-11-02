namespace FundingAllocation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;

    public static class ProviderFundingAllocationExtensions
    {
        public static bool IsMateriallyEquivalentTo(this ProviderFundingAllocation currentProviderFundingAllocation,
            ProviderFundingAllocation otherProviderFundingAllocation)
        {
            var areCurrentLinesEquivalentToOther = IsSourceAndDestinationEquivalent(
                currentProviderFundingAllocation.ProviderFunding.FundingAllocationLines,
                otherProviderFundingAllocation.ProviderFunding.FundingAllocationLines);

            var areOtherLinesEquivalentToCurrent = IsSourceAndDestinationEquivalent(
                otherProviderFundingAllocation.ProviderFunding.FundingAllocationLines,
                currentProviderFundingAllocation.ProviderFunding.FundingAllocationLines);

            return areOtherLinesEquivalentToCurrent && areCurrentLinesEquivalentToOther;
        }

        private static bool IsSourceAndDestinationEquivalent(IReadOnlyCollection<FundingAllocationLine> sourceFundingAllocationLines,
            IReadOnlyCollection<FundingAllocationLine> destinationFundingAllocationLines)
        {
            var areAllSourceLinesOnOtherOrAdditionalOnesAreZero = sourceFundingAllocationLines.All(sourceLine =>
            {
                var matchingLine = destinationFundingAllocationLines.SingleOrDefault(
                    destinationLine =>
                        destinationLine.GetProviderFundingName() == sourceLine.GetProviderFundingName() &&
                        destinationLine.FundingLineCode == sourceLine.FundingLineCode);

                return (matchingLine != null && matchingLine.IsMateriallyEquivalentTo(sourceLine)) || !sourceLine.HaveAnyPeriodsWithPlannedValue();
            });

            return areAllSourceLinesOnOtherOrAdditionalOnesAreZero;
        }
    }
}
