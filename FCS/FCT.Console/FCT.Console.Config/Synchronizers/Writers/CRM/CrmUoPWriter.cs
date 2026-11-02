namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;

    using ExcelTypes;

    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmUoPWriter : CrmConfigWriter<UnitsOfProcurementSheetType, sfa_unitofprocurement>
    {
        protected override void UpdateMatchingEntity(UnitsOfProcurementSheetType row, sfa_unitofprocurement matchingEntity)
        {
            matchingEntity.sfa_UoPCode = row.UoPCode;
            matchingEntity.sfa_procurement = row.Procurement;
            matchingEntity.sfa_name = row.UoPName;
        }

        protected override sfa_unitofprocurement CreateEntity(UnitsOfProcurementSheetType row)
        {
            return new sfa_unitofprocurement
            {
                sfa_name = row.UoPName,
                sfa_UoPCode = row.UoPCode,
                sfa_procurement = row.Procurement
            };
        }

        protected override IEnumerable<sfa_unitofprocurement> GetMatchingEntities(XrmServiceContext crmContext, UnitsOfProcurementSheetType row)
        {
            return from u in crmContext.sfa_unitofprocurementSet
                   where u.sfa_UoPCode == row.UoPCode
                   select u;
        }
    }
}