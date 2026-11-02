namespace FundingAllocation.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public static class FundingAllocationExtensions
    {
        public static FundingAllocationDto ToDto(this FundingAllocation fundingAllocation, ContractItemsMappingResult contractItemsMappings)
        {
            return new FundingAllocationDto
            {
                FundingId = fundingAllocation.FundingId,
                FundingVersion = fundingAllocation.FundingVersion,
                FundingType = contractItemsMappings.FundingTypeCode,
                Period = contractItemsMappings.FundingPeriodCode,
                ContractType = contractItemsMappings.ContractType,
                AllocationFundingStream = fundingAllocation.AllocationFundingStream,
                FSPGroup = contractItemsMappings.FSPGroupCode,
                UKPRN = fundingAllocation.UKPRN,
                Value = fundingAllocation.Value,
                CrmEntityId = fundingAllocation.CrmEntityId
            };
        }

        public static bool IsMateriallyEquivalentTo(this FundingAllocation currentFundingAllocation,
            FundingAllocation otherFundingAllocation)
        {
            var areAllCurrentProviderFundingsOnOther =
                IsSourceAndDestinationEquivalent(currentFundingAllocation, otherFundingAllocation);

            var areAllOtherProviderFundingsOnCurrent =
                IsSourceAndDestinationEquivalent(otherFundingAllocation, currentFundingAllocation);

            return areAllOtherProviderFundingsOnCurrent && areAllCurrentProviderFundingsOnOther;
        }

        private static bool IsSourceAndDestinationEquivalent(FundingAllocation sourceFundingAllocation,
            FundingAllocation destinationFundingAllocation)
        {
            var areAllSourceProviderFundingsOnOther = sourceFundingAllocation.ProviderFundingAllocations.All(sourcePfa =>
            {
                var matchingPfa = destinationFundingAllocation.ProviderFundingAllocations.SingleOrDefault(destinationPfa
                    => destinationPfa.GetProviderFundingName() == sourcePfa.GetProviderFundingName() && destinationPfa.GetFundingName() == sourcePfa.GetFundingName());

                return (matchingPfa != null && matchingPfa.IsMateriallyEquivalentTo(sourcePfa)) || !sourcePfa.ProviderFunding.HasOneOrMoreFundingLinesWithOneOrMoreNonZeroPeriods();
            });

            return areAllSourceProviderFundingsOnOther;
        }

        public static IReadOnlyCollection<FundingAllocationLine> GetFundingAllocationLines(this FundingAllocation fa)
        {
            return fa.ProviderFundingAllocations.SelectMany(pfa => pfa.ProviderFunding.FundingAllocationLines).ToList();
        }
    }
}
