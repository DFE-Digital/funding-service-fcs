namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmFundingPeriodWriter : CrmConfigWriter<FundingPeriodSheetType, sfa_period>
    {
        private readonly CrmHelper _crmHelper = new CrmHelper();

        protected override void UpdateMatchingEntity(FundingPeriodSheetType row, sfa_period matchingFsp)
        {
            matchingFsp.sfa_StartDate = row.StartDate;
            matchingFsp.sfa_EndDate = row.EndDate;
        }

        protected override sfa_period CreateEntity(FundingPeriodSheetType row)
        {
            EntityReference preiodTypeEntityReference = new EntityReference(CrmEntityName.PeriodType,
                _crmHelper.GetLookupPrimaryKey(CrmLookupType.PeriodType, "sfa_periodtypeid", new string[] {row.PeriodTypeCode}));
            sfa_period fundingPeriod = new sfa_period
            {
                sfa_periodname = row.FundingPeriod,
                sfa_PeriodTypeId = preiodTypeEntityReference,
                sfa_StartDate = row.StartDate,
                sfa_EndDate = row.EndDate,
                sfa_Period = row.Period
            };

            return fundingPeriod;
        }

        protected override IEnumerable<sfa_period> GetMatchingEntities(XrmServiceContext crmContext,
            FundingPeriodSheetType row)
        {
            return from fp in crmContext.sfa_periodSet
                                     where fp.sfa_periodname == row.Key
                                     select fp;
        }
    }
}
