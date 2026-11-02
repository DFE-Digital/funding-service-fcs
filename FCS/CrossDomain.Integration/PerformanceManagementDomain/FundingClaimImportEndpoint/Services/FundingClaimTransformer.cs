namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0;
    using DataStore.Models;
    using FundingClaim = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0.FundingClaim;

    public static class FundingClaimTransformer
    {
        public static DataStore.Models.FundingClaim CorpSchemaFundingClaimToDataStoreFundingClaim(FundingClaim corpSchemaFundingClaim)
        {
            string orgId = corpSchemaFundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Contractor.ContractorPKeyAttrs.OrganisationIdentifier;
            int ukprn = corpSchemaFundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Contractor.ContractorNonPKeyAttrs.Ukprn;
            int claimVersion = corpSchemaFundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.VersionNumber;
            string claimTypeName = corpSchemaFundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.ClaimTypeName.ToString();
            string periodTypeCode = corpSchemaFundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Period.PeriodTypePKeyAttrs.PeriodTypeCode.ToString();
            string period = corpSchemaFundingClaim.FundingClaimAllAttrs.First().FundingClaimPKeyAttrs.Period.Period;
            bool hasBeenSigned = corpSchemaFundingClaim.FundingClaimAllAttrs.First().FundingClaimNonPKeyAttrs.HasBeenSigned;
            List<ContractAllocationAllAttrsCT> corpSchemaFundingClaimAllocations = corpSchemaFundingClaim.FundingClaimAllAttrs.First().ContractAllocations;

            DataStore.Models.FundingClaim fundingClaim = new DataStore.Models.FundingClaim(orgId, ukprn, claimVersion, claimTypeName, periodTypeCode, period, hasBeenSigned);
            fundingClaim.Allocations = corpSchemaFundingClaimAllocations.Select(a => TransformCorpSchemaAllocationToDataStoreAllocation(a, fundingClaim.Id)).ToList();

            return fundingClaim;
        }

        private static FundingClaimContractAllocation TransformCorpSchemaAllocationToDataStoreAllocation(ContractAllocationAllAttrsCT corpSchemaAllocation, Guid fundingClaimId)
        {
            string allocationNumber = corpSchemaAllocation.ContractAllocationPKeyAttrs.ContractAllocationNumber;
            string fundingStreamPeriodCode = corpSchemaAllocation.ContractAllocationNonPKeyAttrs.FundingStreamPeriodCode;

            FundingClaimContractAllocation allocation = new FundingClaimContractAllocation(fundingClaimId, allocationNumber, fundingStreamPeriodCode);
            allocation.Deliverables = corpSchemaAllocation.DeliverableLines.Select(d => TransformCorpSchemaDeliverableToDataStoreDeliverale(d, allocation.Id)).ToList();
            return allocation;
        }

        private static FundingClaimDeliverable TransformCorpSchemaDeliverableToDataStoreDeliverale(DeliverableLineAllAttrsCT corpSchemaDeliverable, Guid allocationId)
        {
            int deliverableCode = corpSchemaDeliverable.DeliverableLinePKeyAttrs.DeliverableCode;
            decimal actualValue = corpSchemaDeliverable.DeliverableLineNonPKeyAttrs.ActualValue.GetValueOrDefault();
            decimal forecastValue = corpSchemaDeliverable.DeliverableLineNonPKeyAttrs.ForecastValue.GetValueOrDefault();
            decimal adjustmentValue = corpSchemaDeliverable.DeliverableLineNonPKeyAttrs.AdjustmentValue.GetValueOrDefault();
            decimal? totalDelivery = corpSchemaDeliverable.DeliverableLineNonPKeyAttrs.TotalDelivery;

            FundingClaimDeliverable deliverable = new FundingClaimDeliverable(allocationId, deliverableCode, actualValue, forecastValue, adjustmentValue, totalDelivery);

            return deliverable;
        }
    }
}
