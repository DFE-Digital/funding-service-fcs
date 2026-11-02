namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmAllocationGroupWriter : CrmConfigWriter<ClaimReconciliationAllocationGroupSheetType, sfa_claimreconallocgroup>
    {
        protected override void UpdateMatchingEntity(ClaimReconciliationAllocationGroupSheetType row, sfa_claimreconallocgroup matchingClaimAllocGroup)
        {
            matchingClaimAllocGroup.sfa_name = row.GroupName;
        }

        protected override sfa_claimreconallocgroup CreateEntity(ClaimReconciliationAllocationGroupSheetType claimReconAllocGroup)
        {
            return new sfa_claimreconallocgroup()
            {
                sfa_AllocationGroupCode = claimReconAllocGroup.ClaimReconciliationAllocationGroupCode,
                sfa_name = claimReconAllocGroup.GroupName
            };
        }

        protected override IEnumerable<sfa_claimreconallocgroup> GetMatchingEntities(XrmServiceContext crmContext, ClaimReconciliationAllocationGroupSheetType row)
        {
            return from d in crmContext.sfa_claimreconallocgroupSet
                   where d.sfa_AllocationGroupCode == row.ClaimReconciliationAllocationGroupCode
                   select d;
        }
    }
}
