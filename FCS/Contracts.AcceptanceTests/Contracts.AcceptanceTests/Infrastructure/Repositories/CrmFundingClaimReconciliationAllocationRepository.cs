namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Services;

    public static class CrmFundingClaimReconciliationAllocationRepository
    {
        public static void SetUserEditableValues(
            string contractAllocationNumber,
            string fcrPeriodYear,
            string fcrClaimTypeCode,
            string fcrAllocationGroupCode,
            decimal newReconciliationValue,
            decimal newEarningsBoostValue,
            decimal newClaimAdjustmentValue,
            OptionSetValue claimAdjustmentReason)
        {
            var organizationService = CrmConnectionFactory.GetNonRetryingConnection();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                sfa_fcrallocation fundingClaimAllocation = (
                    from fcra in xrmContext.sfa_fcrallocationSet
                    join fcr in xrmContext.sfa_fundingclaimreconciliationSet on fcra.sfa_FundingClaimReconciliationId.Id equals fcr.Id
                    join fp in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals fp.sfa_periodId
                    join ct in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.sfa_claimtypeId
                    join crag in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals crag.Id
                    where
                        fp.sfa_Period == fcrPeriodYear &&
                        ct.sfa_name == fcrClaimTypeCode &&
                        crag.sfa_AllocationGroupCode == fcrAllocationGroupCode &&
                        fcra.sfa_name == contractAllocationNumber
                    select fcra
                    ).Single();

                sfa_fcrallocation updatedFcrAllocation = new sfa_fcrallocation
                {
                    Id = fundingClaimAllocation.Id,
                    sfa_ReconciliationValue = newReconciliationValue,
                    SFA_EarningsBoostValue = newEarningsBoostValue,
                    sfa_claimadjustmentvalue = newClaimAdjustmentValue,
                    sfa_claimadjustmentreason = claimAdjustmentReason
                };

                organizationService.Update(updatedFcrAllocation);
            }
        }
    }
}
