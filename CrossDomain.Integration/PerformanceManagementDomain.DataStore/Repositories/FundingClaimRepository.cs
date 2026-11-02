namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Data.Entity;
    using System.ComponentModel;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using Models;
    using DtoFundingClaim = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;
    using FundingClaim = Models.FundingClaim;

    public class FundingClaimRepository : PerformanceManagementRepositoryBase<FundingClaim>, IFundingClaimRepository
    {
        private static IPerformanceManagementDbContext _dbContext;

        public FundingClaimRepository(IPerformanceManagementDbContext dbContext) : base(dbContext.FundingClaims)
        {
            _dbContext = dbContext;
        }

        public DtoFundingClaim GetFundingClaimByNaturalKey(FundingClaimNaturalKey naturalKey)
        {
            string enumDesc = naturalKey.ClaimTypeName.ToString();
            var fundingClaim =  _dbContext.FundingClaims
                .Where(
                    x => x.OrganisationIdentifier == naturalKey.OrganisationIdentifier &&
                    x.VersionNumber == naturalKey.VersionNumber &&
                    x.ClaimTypeName == enumDesc &&
                    x.PeriodTypeCode == naturalKey.PeriodTypeCode &&
                    x.Period == naturalKey.Period)
                .Include(i => i.Allocations.Select(a => a.Deliverables)).FirstOrDefault();

            return ConvertFundingClaimToDto(fundingClaim);
        }

        public List<DtoFundingClaim> RetrieveAllFundingClaimsForPeriodAndClaimType(string period, string claimTypeName)
        {
            return _dbContext.FundingClaimsWithAllocations.Where(fc => fc.ClaimTypeName == claimTypeName
                                                     && fc.Period == period)
                    .Include(x => x.Allocations.Select(a => a.Deliverables))
                    .AsEnumerable()
                    .Select(ConvertFundingClaimToDto)
                    .ToList();
        }

        public void AddFundingClaims(List<FundingClaim> dataStoreFundingClaims)
        {
            ((DbSet<FundingClaim>) _dbContext.FundingClaims).AddRange(dataStoreFundingClaims);
            _dbContext.SaveChanges();
        }

        public int GetCountOfFundingClaimsForCollection(string period, string claimTypeName)
        {
            return _dbContext.FundingClaims.Count(fc => fc.ClaimTypeName == claimTypeName
                                                        && fc.Period == period);
        }

        private DtoFundingClaim ConvertFundingClaimToDto(FundingClaim fundingClaim)
        {
            return new DtoFundingClaim
            {
                Period = fundingClaim.Period,
                ClaimTypeName = (ClaimTypeName)Enum.Parse(typeof (ClaimTypeName), fundingClaim.ClaimTypeName.Replace(" ", string.Empty).ToUpper()),
                ContractAllocations = fundingClaim.Allocations.Select(ConvertAllocationToDto).ToList(),
                HasBeenSigned = fundingClaim.HasBeenSigned,
                PeriodTypeCode = (PeriodTypeCode) Enum.Parse(typeof (PeriodTypeCode), fundingClaim.PeriodTypeCode),
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
