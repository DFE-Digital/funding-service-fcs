namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmAgencyWriter: CrmConfigWriter<AgencySheetType, sfa_agency>
    {
        protected override void UpdateMatchingEntity(AgencySheetType row, sfa_agency matchingAgency)
        {
            matchingAgency.sfa_agencyshortcode = row.AgencyShortCode;
            matchingAgency.sfa_description = row.Description;
            matchingAgency.sfa_contractreferenceprefix = row.ContractReferencePrefix;
        }

        protected override sfa_agency CreateEntity(AgencySheetType agencySheet)
        {
            return new sfa_agency()
            {
                sfa_agencycode = agencySheet.AgencyCode,
                sfa_agencyshortcode = agencySheet.AgencyShortCode,
                sfa_description = agencySheet.Description,
                sfa_contractreferenceprefix = agencySheet.ContractReferencePrefix
            };
        }

        protected override IEnumerable<sfa_agency> GetMatchingEntities(XrmServiceContext crmContext, AgencySheetType row)
        {
            return from d in crmContext.sfa_agencySet
                   where d.sfa_agencycode == row.AgencyCode
                   select d;
        }

    }
}
