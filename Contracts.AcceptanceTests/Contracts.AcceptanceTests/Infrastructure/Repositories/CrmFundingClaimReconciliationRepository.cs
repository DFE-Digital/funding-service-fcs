namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Services;

    public static class CrmFundingClaimReconciliationRepository
    {
        public static void DeleteFundingClaimReconciliationsForUkprn(string ukprn)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_fundingclaimreconciliationSet
                    .Where(fcr => fcr.sfa_ukprn == ukprn)
                    .Select(fcr => fcr.Id)
                    .ForEach(id =>
                    {
                        organizationService.Delete("sfa_fundingclaimreconciliation", id);
                    });
            }
        }

        public static void SetFundingClaimReconciliationStatusAndSubstatus(string ukprn, string fundingPeriod, string claimType,
                                                    string allocGroupCode, int claimVersion, sfa_sfastatuscode status, sfa_sfasubstatuscode substatus)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                var relevantFcrId = (from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                                   join fp in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals fp.Id
                                   join ag in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id
                                       equals
                                       ag.Id
                                   join ct in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.Id
                                   where fcr.sfa_ukprn == ukprn
                                         && fp.sfa_Period == fundingPeriod
                                         && ct.sfa_name == claimType
                                         && ag.sfa_AllocationGroupCode == allocGroupCode
                                         && fcr.sfa_ClaimVersionNumber == claimVersion
                                   select fcr.Id).Single();

                sfa_fundingclaimreconciliation fcrToUpdate = new sfa_fundingclaimreconciliation
                {
                    Id = relevantFcrId,
                    sfa_StatusCodeEnum = status,
                    sfa_substatusEnum = substatus,
                    EntityState = EntityState.Changed
                };
               
                organizationService.Update(fcrToUpdate);
            }
        }

        public static Guid GetFundingClaimReconciliationIdByNaturalKey(string ukprn, string fundingPeriod, string claimType, string allocationGroupCode, int claimVersion)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                Guid fundingClaimReconciliationId = (
                    from fcr in xrmContext.sfa_fundingclaimreconciliationSet
                    join fp in xrmContext.sfa_periodSet on fcr.sfa_FundingPeriodId.Id equals fp.Id
                    join ag in xrmContext.sfa_claimreconallocgroupSet on fcr.sfa_AllocationGroupId.Id equals ag.Id
                    join ct in xrmContext.sfa_claimtypeSet on fcr.sfa_ClaimTypeId.Id equals ct.Id
                    where
                        fcr.sfa_ukprn == ukprn
                        && fp.sfa_Period == fundingPeriod
                        && ct.sfa_name == claimType
                        && ag.sfa_AllocationGroupCode == allocationGroupCode
                        && fcr.sfa_ClaimVersionNumber == claimVersion
                    select fcr.Id)
                    .Single();

                return fundingClaimReconciliationId;
            }
        }
    }
}
