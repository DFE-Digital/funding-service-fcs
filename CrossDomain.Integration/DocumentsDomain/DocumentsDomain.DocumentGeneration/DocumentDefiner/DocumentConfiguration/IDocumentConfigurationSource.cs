namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using Dtos;

    public interface IDocumentConfigurationSource
    {
        int GetFundingStreamPeriodDisplayOrder(contractAllocationsContractAllocation contractAllocation);

        bool ShouldDisplayDeliverableOnSummaryOfFunding(contractAllocationsContractAllocation contractAllocation, contractDeliverablesTypeContractDeliverable deliverable);

        bool ShouldDisplayDeliverableOnSummaryOfFunding(string fundingStreamPeriodCode, int deliverableCode);

        string GetAllocationName(contractAllocationsContractAllocation allocation);

        string GetDeliverableNameForSummaryOfFunding(contractAllocationsContractAllocation allocation, int deliverableCode);
        
        string GetDeliverableNameForSummaryOfFunding(string fundingStreamPeriodCode, int deliverableCode);

        bool IsFundingAgreementRequiredForAllocation(contractAllocationsContractAllocation contractAllocation);

        string GetFundingAgreementTitleFromAllocation(contractAllocationsContractAllocation contractAllocation);

        DeliverableConfiguration GetDeliverableConfigurationForFundingAgreement(contractAllocationsContractAllocation allocation, int deliverableCode);

        DeliverableConfiguration[] GetMandatoryDeliverablesOnFundingAgreementForAllocation(contractAllocationsContractAllocation contractAllocation);

        FundingAgreementTemplate GetFundingAgreementTemplateNamesForAllocation(string fundingStream, string fundingStreamPeriodCode, string fundingType);

        IEnumerable<DeliverableConfiguration> GetDeliverableConfigurationForSummaryOfFunding(contractType contract);

        FundingTypeFundingPeriod GetFundingTypeFundingPeriod(string fundingTypeCode, string fundingPeriodName);
    }
}
