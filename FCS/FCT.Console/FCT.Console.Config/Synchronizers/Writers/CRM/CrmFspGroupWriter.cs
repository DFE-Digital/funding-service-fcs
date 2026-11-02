namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmFspGroupWriter : CrmConfigWriter<FspGroupSheetType, sfa_fspgroup>
    {
        protected override void UpdateMatchingEntity(FspGroupSheetType row, sfa_fspgroup matchingEntity)
        {
            matchingEntity.sfa_name = row.FSPGroupCode;
        }

        protected override sfa_fspgroup CreateEntity(FspGroupSheetType row)
        {
            return new sfa_fspgroup
            {
                sfa_name = row.FSPGroupCode
            };
        }

        protected override IEnumerable<sfa_fspgroup> GetMatchingEntities(XrmServiceContext crmContext, FspGroupSheetType row)
        {
            return crmContext.sfa_fspgroupSet.Where(fspG => fspG.sfa_name == row.FSPGroupCode).ToList();
        }
    }
}
