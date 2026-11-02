namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class CrmFcrDataFixes
    {
        [TestMethod, TestCategory("DataFix_Not_Possible_R65")]
        public void ShouldUpdateFcrAndFcrAllocationWithClaimAdjustmentAndAdjustedValues()
        {
            IReadOnlyCollection<FcrInfo> fcrInfos = GetFcrInfos();

            fcrInfos.ForEach(UpdateFcrInCrm);
        }

        private void UpdateFcrInCrm(FcrInfo fcrInfo)
        {
            var fcr = new sfa_fundingclaimreconciliation
            {
                Id = fcrInfo.FcrId,
                sfa_adjustedcappedclaimedvalue = fcrInfo.CappedClaimValue,
                sfa_claimadjustmentvalue = 0,
                EntityState = EntityState.Changed
            };

            var fcrAllocations = fcrInfo.AllocationIds.Select(fcrAllocationId => new sfa_fcrallocation
            {
                Id = fcrAllocationId,
                sfa_adjustedcappedclaimedvalue = fcrInfo.CappedClaimValue,
                sfa_claimadjustmentvalue = 0
            }).ToList();

            AddFcrAllocationsToFcr(fcr, fcrAllocations);

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(fcr);
        }

        private static void AddFcrAllocationsToFcr(sfa_fundingclaimreconciliation fcr,
            IReadOnlyCollection<sfa_fcrallocation> fcrAllocations)
        {
            Relationship relationship = new Relationship("sfa_sfa_fundingclaimreconciliation_sfa_fcrall")
            {
                PrimaryEntityRole = EntityRole.Referenced
            };

            EntityCollection fcrAllocationEntityCollection = new EntityCollection()
            {
                EntityName = sfa_fcrallocation.EntityLogicalName
            };

            fcrAllocationEntityCollection.Entities.AddRange(fcrAllocations);

            fcr.RelatedEntities.Add(relationship, fcrAllocationEntityCollection);
        }

        private IReadOnlyCollection<FcrInfo> GetFcrInfos()
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                var fcrGroups = (
                        from fcr in context.sfa_fundingclaimreconciliationSet
                        join fcra in context.sfa_fcrallocationSet on fcr.Id equals fcra.sfa_FundingClaimReconciliationId
                            .Id
                        select new {fcr.Id, FcrAId = fcra.sfa_fcrallocationId, fcr.sfa_CappedClaimedValue}
                    ).AsEnumerable()
                    .GroupBy(fcr => fcr.Id)
                    .ToList();

                return fcrGroups.Select(g =>
                {
                    return new FcrInfo(g.Key, g.First().sfa_CappedClaimedValue, g.Select(r => r.FcrAId.Value).ToList());
                }).ToList();
            }
        }

        private class FcrInfo
        {
            public FcrInfo(Guid fcrId, decimal? cappedClaimValue, IReadOnlyCollection<Guid> allocationIds)
            {
                FcrId = fcrId;
                CappedClaimValue = cappedClaimValue;
                AllocationIds = allocationIds;
            }

            public Guid FcrId { get; }

            public decimal? CappedClaimValue { get; }

            public IReadOnlyCollection<Guid> AllocationIds { get; }
        }
    }
}
