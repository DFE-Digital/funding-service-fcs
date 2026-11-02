namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmPeriodTypeWriter : CrmConfigWriter<PeriodTypeSheetType, sfa_periodtype>
    {
        protected override void UpdateMatchingEntity(PeriodTypeSheetType row, sfa_periodtype matchingEntity)
        {
            matchingEntity.sfa_PeriodTypeName = row.PeriodTypeName;
        }

        protected override sfa_periodtype CreateEntity(PeriodTypeSheetType row)
        {
            return new sfa_periodtype
            {
                sfa_periodtypecode = row.PeriodTypeCode,
                sfa_PeriodTypeName = row.PeriodTypeName
            };
        }

        protected override IEnumerable<sfa_periodtype> GetMatchingEntities(XrmServiceContext crmContext, PeriodTypeSheetType row)
        {
            return from pt in crmContext.sfa_periodtypeSet
                   where pt.sfa_periodtypecode == row.PeriodTypeCode
                   select pt;
        }
    }
}
