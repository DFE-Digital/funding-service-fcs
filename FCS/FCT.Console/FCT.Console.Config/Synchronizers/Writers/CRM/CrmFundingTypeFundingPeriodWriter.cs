namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmFundingTypeFundingPeriodWriter : CrmConfigWriter<FundingTypePeriodSheetType, sfa_fundingtypefundingperiod>
    {
        protected override void UpdateMatchingEntity(FundingTypePeriodSheetType row, sfa_fundingtypefundingperiod matchingEntity)
        {
            matchingEntity.sfa_ApprovalTypeEnum = (sfa_approvaltype)Enum.Parse(typeof(sfa_approvaltype), row.ApprovalType, ignoreCase: true);
            matchingEntity.sfa_skipdocumentmerge = row.SkipDocumentMerge;
            matchingEntity.sfa_generatecontractdocumentation = row.DocumentsRequired;
        }

        protected override sfa_fundingtypefundingperiod CreateEntity(FundingTypePeriodSheetType row)
        {
            return new sfa_fundingtypefundingperiod
            {
                sfa_FundingTypeId = GetFundingTypeEntityReference(row.FundingTypeCode),
                sfa_name = row.FundingTypeFundingPeriodName,
                sfa_FundingPeriodId = GetFundingPeriodEntityReference(row.FundingPeriod),
                sfa_ApprovalTypeEnum = (sfa_approvaltype)Enum.Parse(typeof(sfa_approvaltype), row.ApprovalType)
            };
        }

        private EntityReference GetFundingPeriodEntityReference(string fundingPeriod)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from p in crmContext.sfa_periodSet
                                  where p.sfa_periodname == fundingPeriod
                                  select p;

                return entityQuery.Single().ToEntityReference();
            }
        }

        protected override IEnumerable<sfa_fundingtypefundingperiod> GetMatchingEntities(XrmServiceContext crmContext, FundingTypePeriodSheetType row)
        {
            return from ftfp in crmContext.sfa_fundingtypefundingperiodSet
                   join ft in crmContext.sfa_fundingtypeSet on ftfp.sfa_FundingTypeId.Id equals ft.sfa_fundingtypeId
                   join fp in crmContext.sfa_periodSet on ftfp.sfa_FundingPeriodId.Id equals fp.sfa_periodId
                   where ft.sfa_fundingtypecode == row.FundingTypeCode
                         && fp.sfa_periodname == row.FundingPeriod
                   select ftfp;
        }

        private EntityReference GetFundingTypeEntityReference(string fundingTypeCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from ft in crmContext.sfa_fundingtypeSet
                                  where ft.sfa_fundingtypecode == fundingTypeCode
                                  select ft;
                return entityQuery.Single().ToEntityReference();
            }
        }
    }
}
