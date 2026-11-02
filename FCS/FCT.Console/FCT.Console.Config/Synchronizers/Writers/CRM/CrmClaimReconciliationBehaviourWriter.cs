namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmClaimReconciliationBehaviourWriter : CrmConfigWriter<ClaimReconciliationBehaviourSheetType, sfa_claimreconciliationbehaviour>
    {
        protected override void UpdateMatchingEntity(ClaimReconciliationBehaviourSheetType row,
                                                     sfa_claimreconciliationbehaviour matchingEntity)
        {
            matchingEntity.sfa_publicationclosedate = row.PublicationCloseDate;
        }

        protected override sfa_claimreconciliationbehaviour CreateEntity(ClaimReconciliationBehaviourSheetType row)
        {
            return new sfa_claimreconciliationbehaviour
            {
                sfa_allocationgroup = GetAllocationGroup(row.ClaimReconciliationAllocationGroupCode),
                sfa_claimtype = GetClaimType(row.ClaimTypeCode),
                sfa_fundingperiod = GetFundingPeriod(row.FundingPeriod),
                sfa_publicationclosedate = row.PublicationCloseDate,
                sfa_name = GetName(row.ClaimCollectionCode, row.ClaimReconciliationAllocationGroupCode)
            };
        }

        protected override IEnumerable<sfa_claimreconciliationbehaviour> GetMatchingEntities(XrmServiceContext crmContext, ClaimReconciliationBehaviourSheetType row)
        {
            string name = GetName(row.ClaimCollectionCode, row.ClaimReconciliationAllocationGroupCode);

            return from crb in crmContext.sfa_claimreconciliationbehaviourSet
                    join ag in crmContext.sfa_claimreconallocgroupSet on crb.sfa_allocationgroup.Id equals
                        ag.sfa_claimreconallocgroupId.Value
                    join ct in crmContext.sfa_claimtypeSet on crb.sfa_claimtype.Id equals ct.sfa_claimtypeId.Value
                    join fp in crmContext.sfa_periodSet on crb.sfa_fundingperiod.Id equals fp.sfa_periodId.Value
                    where crb.sfa_name == name
                          && ag.sfa_AllocationGroupCode == row.ClaimReconciliationAllocationGroupCode
                          && ct.sfa_ClaimTypeCode == row.ClaimTypeCode
                          && fp.sfa_periodname == row.FundingPeriod
                    select crb;
        }

        private EntityReference GetAllocationGroup(string allocationGroupCode)
        {
            using (var context = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return context.sfa_claimreconallocgroupSet.Single(ag => ag.sfa_AllocationGroupCode == allocationGroupCode)
                              .ToEntityReference();
            }
        }

        private EntityReference GetClaimType(string claimTypeCode)
        {
            using (var context = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return context.sfa_claimtypeSet.Single(ct => ct.sfa_ClaimTypeCode == claimTypeCode)
                              .ToEntityReference();
            }
        }

        private EntityReference GetFundingPeriod(string fundingPeriodName)
        {
            using (var context = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return context.sfa_periodSet.Single(p => p.sfa_periodname == fundingPeriodName)
                              .ToEntityReference();
            }
        }

        private string GetName(string claimCollectionCode, string allocationGroupCode)
        {
            return $"{claimCollectionCode}_{allocationGroupCode}";
        }
    }
}