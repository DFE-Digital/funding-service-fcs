namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmClaimTypeWriter : CrmConfigWriter<ClaimTypeSheetType, sfa_claimtype>
    {
        protected override void UpdateMatchingEntity(ClaimTypeSheetType row, sfa_claimtype matchingEntity)
        {
            matchingEntity.sfa_name = row.Name;
        }

        protected override sfa_claimtype CreateEntity(ClaimTypeSheetType row)
        {
            sfa_claimtype claimType = new sfa_claimtype
            {
                sfa_ClaimTypeCode = row.ClaimTypeCode,
                sfa_name = row.Name
            };

            return claimType;
        }

        protected override IEnumerable<sfa_claimtype> GetMatchingEntities(XrmServiceContext crmContext, ClaimTypeSheetType row)
        {
            return from ct in crmContext.sfa_claimtypeSet
                                     where ct.sfa_ClaimTypeCode == row.ClaimTypeCode
                                     select ct;
        }
    }
}
