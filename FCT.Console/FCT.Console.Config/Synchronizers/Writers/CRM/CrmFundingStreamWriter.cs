namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmFundingStreamWriter : CrmConfigWriter<FundingStreamSheetType, sfa_fundingstream>
    {
        protected override void UpdateMatchingEntity(FundingStreamSheetType row, sfa_fundingstream matchingFsp)
        {
            matchingFsp.sfa_fundingstreamname = row.Name;
            matchingFsp.sfa_AgencyCode = row.AgencyCode;
            // we no longer want to write the sfa_fundingstreamshortcode to CRM
            //matchingFsp.sfa_fundingstreamshortcode = row.FinanceShortCode;
            matchingFsp.sfa_StartDate = row.StartDate;
            matchingFsp.sfa_EndDate = row.EndDate;
        }

        protected override sfa_fundingstream CreateEntity(FundingStreamSheetType row)
        {
            sfa_fundingstream fundingStream = new sfa_fundingstream
            {
                sfa_fundingstreamcode = row.Code,
                sfa_fundingstreamname = row.Name,
                sfa_AgencyCode = row.AgencyCode,
                // we no longer want to write the sfa_fundingstreamshortcode to CRM
                //sfa_fundingstreamshortcode = row.FinanceShortCode,
                sfa_StartDate = row.StartDate,
                sfa_EndDate = row.EndDate
            };

            return fundingStream;
        }

        protected override IEnumerable<sfa_fundingstream> GetMatchingEntities(XrmServiceContext crmContext, FundingStreamSheetType row)
        {
            return from fs in crmContext.sfa_fundingstreamSet
                                     where fs.sfa_fundingstreamcode == row.Code
                                     select fs;
        }
    }
}
