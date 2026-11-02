namespace PerformanceManagementDomain.PullFundingClaim.Extensions
{
    using System.Linq;
    using DTOs;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public static class FundingClaimApiDtoExtensions
    {
        public static FundingClaim ToDataModel(this FundingClaimApiDto dto)
        {
            var fundingClaim = new FundingClaim(
                organisationIdentifier: dto.OrganisationIdentifier,
                ukprn: int.Parse(dto.Ukprn),
                versionNumber: dto.VersionNumber,
                claimTypeName: dto.FcsClaimTypeName,
                periodTypeCode: dto.PeriodTypeCode,
                period: dto.Period,
                hasBeenSigned: bool.Parse(dto.HasBeenSigned.ToUpper()));

            fundingClaim.Allocations = dto.ContractAllocations.Select(a => new FundingClaimContractAllocation(
                fundingClaimId: fundingClaim.Id,
                contractAllocationNumber: a.ContractAllocationNumber,
                fundingStreamPeriodCode: a.FundingStreamPeriodCode)
           ).ToList();

            fundingClaim.Allocations.ToList().ForEach(modelAllocation =>
            {
                var dtoAllocation = dto.ContractAllocations.Single(dtoA =>
                    dtoA.ContractAllocationNumber == modelAllocation.ContractAllocationNumber);
                modelAllocation.Deliverables = dtoAllocation.DeliverableCodes.Select(dtoDeliverable =>
                    new FundingClaimDeliverable(
                        contractAllocationId: modelAllocation.Id,
                        deliverableCode: dtoDeliverable.DeliverableCodeValue,
                        actualValue: dtoDeliverable.ActualValue,
                        forecastValue: dtoDeliverable.ForecastValue,
                        adjustmentValue: dtoDeliverable.AdjustmentValue,
                        totalDelivery: dtoDeliverable.TotalDelivery)).ToList();
            });
            return fundingClaim;
        }
    }
}
