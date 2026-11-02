namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix2
{
    using System;
    using DocumentConfiguration;
    using CrossDomain.Integration.Entities.CorporateContract;

    public static class AllocationSelectionFilter
    {
        public static Func<contractAllocationsContractAllocation, bool> GetContractAllocationFilter(
            string fundingTypeCode,
            string fundingPeriod,
            DocumentPartCreators.ContractIntent intent,
            IDocumentConfigurationSource documentConfigurationSource)
        {
            var fundingTypeFundingPeriod =
                documentConfigurationSource.GetFundingTypeFundingPeriod(fundingTypeCode, fundingPeriod);

            if (fundingTypeFundingPeriod.OnlyGenerateFundingAgreementForNewOrUpdatedAllocations)
            {
                return ca => documentConfigurationSource.IsFundingAgreementRequiredForAllocation(ca) && (intent == DocumentPartCreators.ContractIntent.IsNewRevisedNewOrUpdateDraft || ca.HasBeenAddedOrUpdated);
            }

            return documentConfigurationSource.IsFundingAgreementRequiredForAllocation;
        }
    }
}