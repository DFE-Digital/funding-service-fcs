namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System;
    using System.Linq;
    using System.Data.Entity;
    using System.ComponentModel;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using DtoFundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;
    using FundingClaim = SFA.FCT.PerformanceManagementDomain.DataStore.Models.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    public class FundingClaimRepository : IFundingClaimRepository
    {
        public async Task<DtoFundingClaim> GetFundingClaimByNaturalKey(FundingClaimNaturalKey naturalKey, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                string enumDesc = naturalKey.ClaimTypeName.ToString();

                var fundingClaim = await context.FundingClaims
                    .Where(
                        x => x.OrganisationIdentifier == naturalKey.OrganisationIdentifier &&
                             x.VersionNumber == naturalKey.VersionNumber &&
                             x.ClaimTypeName == enumDesc &&
                             x.PeriodTypeCode == naturalKey.PeriodTypeCode &&
                             x.Period == naturalKey.Period)
                    .Include(i => i.Allocations.Select(a => a.Deliverables))
                    .FirstOrDefaultAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);

                return ConvertFundingClaimToDto(fundingClaim);
            }
        }

        private DtoFundingClaim ConvertFundingClaimToDto(FundingClaim fundingClaim)
        {
            return new DtoFundingClaim
            {
                Period = fundingClaim.Period,
                ClaimTypeName = (ClaimTypeName)Enum.Parse(typeof(ClaimTypeName), fundingClaim.ClaimTypeName.Replace(" ", string.Empty).ToUpper()),
                ContractAllocations = fundingClaim.Allocations.Select(ConvertAllocationToDto).ToList(),
                HasBeenSigned = fundingClaim.HasBeenSigned,
                PeriodTypeCode = (PeriodTypeCode)Enum.Parse(typeof(PeriodTypeCode), fundingClaim.PeriodTypeCode),
                Contractor = new Contractor { OrganisationIdentifier = fundingClaim.OrganisationIdentifier, Ukprn = fundingClaim.Ukprn },
                VersionNumber = fundingClaim.VersionNumber
            };
        }

        private ContractAllocation ConvertAllocationToDto(FundingClaimContractAllocation allocation)
        {
            return new ContractAllocation
            {
                ContractAllocationNumber = allocation.ContractAllocationNumber,
                FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                DeliverableLines = allocation.Deliverables.Select(ConvertDeliverableToDto).ToList()
            };
        }

        private DeliverableLine ConvertDeliverableToDto(FundingClaimDeliverable deliverable)
        {
            return new DeliverableLine
            {
                DeliverableCode = deliverable.DeliverableCode,
                ActualValue = deliverable.ActualValue,
                AdjustmentValue = deliverable.AdjustmentValue,
                ForecastValue = deliverable.ForecastValue,
                TotalDelivery = deliverable.TotalDelivery
            };
        }

        public class FundingClaimNaturalKey
        {
            public string OrganisationIdentifier { get; set; }
            public int VersionNumber { get; set; }
            public ClaimTypeNames ClaimTypeName { get; set; }
            public string PeriodTypeCode { get; set; }
            public string Period { get; set; }
        }

        public enum ClaimTypeNames
        {
            [Description("MID YEAR")]
            MIDYEAR,

            [Description("YEAR END")]
            YEAREND,

            FINAL
        }
    }
}