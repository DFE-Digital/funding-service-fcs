namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System.Linq;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0;
    using global::PerformanceManagementDomain.PullFundingClaim.DTOs;

    public static class FundingClaimCorporateSchemaExtensions
    {
        public static FundingClaimApiDto ToApiDto(this FundingClaim fundingClaim)
        {
            FundingClaimAllAttrsCT fcAttributes = fundingClaim.FundingClaimAllAttrs.Single();

            return new FundingClaimApiDto
            {
                OrganisationIdentifier = fcAttributes.FundingClaimPKeyAttrs.Contractor.ContractorPKeyAttrs.OrganisationIdentifier,
                Ukprn = fcAttributes.FundingClaimPKeyAttrs.Contractor.ContractorNonPKeyAttrs.Ukprn.ToString(),
                VersionNumber = fcAttributes.FundingClaimPKeyAttrs.VersionNumber,
                ClaimTypeName = fcAttributes.FundingClaimPKeyAttrs.ClaimTypeName,
                PeriodTypeCode = fcAttributes.FundingClaimPKeyAttrs.Period.PeriodTypePKeyAttrs.PeriodTypeCode.ToString(),
                Period = fcAttributes.FundingClaimPKeyAttrs.Period.Period,
                HasBeenSigned = fcAttributes.FundingClaimNonPKeyAttrs.HasBeenSigned.ToString(),
                ContractAllocations = fcAttributes.ContractAllocations.Select(ca => new ContractAllocationApiDto
                {
                    ContractAllocationNumber = ca.ContractAllocationPKeyAttrs.ContractAllocationNumber,
                    FundingStreamPeriodCode = ca.ContractAllocationNonPKeyAttrs.FundingStreamPeriodCode,
                    MaximumContractValue = ca.ContractAllocationNonPKeyAttrs.maximumContractValue.GetValueOrDefault(),
                    DeliverableCodes = ca.DeliverableLines.Select(d => new DeliverableCodeApiDto
                    {
                        DeliverableCodeValue = d.DeliverableLinePKeyAttrs.DeliverableCode,
                        ActualVolume = d.DeliverableLineNonPKeyAttrs.ActualVolume.GetValueOrDefault(),
                        ActualValue = d.DeliverableLineNonPKeyAttrs.ActualValue.GetValueOrDefault(),
                        ForecastValue = d.DeliverableLineNonPKeyAttrs.ForecastValue.GetValueOrDefault(),
                        AdjustmentValue = d.DeliverableLineNonPKeyAttrs.AdjustmentValue.GetValueOrDefault(),
                        TotalDelivery = d.DeliverableLineNonPKeyAttrs.TotalDelivery.GetValueOrDefault()
                    }).ToList()
                }).ToList()
            };
        }
    }
}
