namespace PerformanceManagementDomain.RecalculationInitiated.Repositories
{
    using System;
    using System.Linq;
    using Dto;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class FundingClaimReconciliationRepository : IFundingClaimReconciliationRepository
    {
        private readonly IOrganizationService _organizationService;

        public FundingClaimReconciliationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public FundingClaimReconciliationInfo GetFundingClaimReconciliationInfo(Guid fundingClaimReconciliationId)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                var fundingClaim = (
                    from fcra in context.sfa_fcrallocationSet
                    join fcr in context.sfa_fundingclaimreconciliationSet on fcra.sfa_FundingClaimReconciliationId.Id equals fcr.sfa_fundingclaimreconciliationId
                    join a in context.AccountSet on fcr.sfa_ProviderId.Id equals a.AccountId.Value
                    join p in context.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals p.sfa_periodId.Value
                    join pt in context.sfa_periodtypeSet on p.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId.Value
                    join ct in context.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.sfa_claimtypeId.Value
                    join ag in context.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals ag.sfa_claimreconallocgroupId.Value
                    where fcr.sfa_fundingclaimreconciliationId == fundingClaimReconciliationId
                    select new
                    {
                        FcrId = fcr.sfa_fundingclaimreconciliationId.Value,
                        OrganisationIdentifier = a.sfa_OrganisationID,
                        ClaimVersionNumber = fcr.sfa_ClaimVersionNumber.Value,
                        ClaimTypeName = ct.sfa_name,
                        PeriodTypeCode = pt.sfa_periodtypecode,
                        Period = p.sfa_Period,
                        AllocationGroupCode = ag.sfa_AllocationGroupCode,
                        ClaimAdjustmentValue = fcra.sfa_claimadjustmentvalue ?? 0,
                        AllocationId = fcra.sfa_ContractAllocationId.Id,
                        EarningsBoostValue = fcra.SFA_EarningsBoostValue ?? 0,
                    })
                    .AsEnumerable()
                    .GroupBy(fcra => new
                    {
                        fcra.FcrId,
                        fcra.OrganisationIdentifier,
                        fcra.ClaimVersionNumber,
                        fcra.ClaimTypeName,
                        fcra.PeriodTypeCode,
                        fcra.Period,
                        fcra.AllocationGroupCode,
                        fcra.AllocationId
                    })
                    .Single();

                string deliveryOrgId = GetDeliveryOrgId(fundingClaim.Key.AllocationId);

                return new FundingClaimReconciliationInfo(
                    fundingClaim.Key.FcrId,
                    deliveryOrgId ?? fundingClaim.Key.OrganisationIdentifier,
                    fundingClaim.Key.ClaimVersionNumber,
                    fundingClaim.Key.ClaimTypeName,
                    fundingClaim.Key.PeriodTypeCode,
                    fundingClaim.Key.Period,
                    fundingClaim.Key.AllocationGroupCode,
                    fundingClaim.Select(fcra => new FundingClaimReconciliationAllocationInfo(fcra.ClaimAdjustmentValue, fcra.EarningsBoostValue)).ToList());
            }
        }

        private string GetDeliveryOrgId(Guid allocationId)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                return (from ca in context.sfa_contractallocationSet
                    join a in context.AccountSet on ca.sfa_deliveryorganisationprovider.Id equals a.AccountId.Value
                    where ca.sfa_contractallocationId == allocationId
                    select a.sfa_OrganisationID).SingleOrDefault();
            }
        }
    }
}