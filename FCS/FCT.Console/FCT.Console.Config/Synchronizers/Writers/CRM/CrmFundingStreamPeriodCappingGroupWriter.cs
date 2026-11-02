namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Common.Crm;

    public class CrmFundingStreamPeriodCappingGroupWriter : CrmConfigWriter<FundingStreamPeriodCappingGroupSheetType, Entity>
    {
        private const string CappinggroupsEntityName = "sfa_cappinggroups";
        private const string NameColumnName = "sfa_name";
        private const string FundingstreamperiodColumnName = "sfa_fundingstreamperiod";
        private const string DeliverablecappinggroupColumnName = "sfa_deliverablecappinggroup";
        private const string AllowunderdeliverytobereusedColumnName = "sfa_allowunderdeliverytobereused";
        private const string AllowoverdeliverytobeoffsetColumnName = "sfa_allowoverdeliverytobeoffset";

        protected override void UpdateMatchingEntity(FundingStreamPeriodCappingGroupSheetType row, Entity matchingEntity)
        {
            var fundingStreamPeriodEntityRef = GetFundingStreamPeriodEntityReference(row.FundingStreamPeriod);

            matchingEntity[NameColumnName] = row.Name;
            matchingEntity[FundingstreamperiodColumnName] = fundingStreamPeriodEntityRef;
            matchingEntity[DeliverablecappinggroupColumnName] = CrmOptionSetFactory.CreateCappingGroupFromString(row.CappingGroupName);
            matchingEntity[AllowunderdeliverytobereusedColumnName] = row.AllowUnderDeliveryToBeReUsed;
            matchingEntity[AllowoverdeliverytobeoffsetColumnName] = row.AllowOverDeliveryToBeOffset;
        }

        protected override Entity CreateEntity(FundingStreamPeriodCappingGroupSheetType row)
        {
            var fundingStreamPeriodEntityRef = GetFundingStreamPeriodEntityReference(row.FundingStreamPeriod);

            Entity sfaCappingGroup = new Entity(CappinggroupsEntityName);
            sfaCappingGroup.Attributes.Add(NameColumnName, row.Name);
            sfaCappingGroup.Attributes.Add(FundingstreamperiodColumnName, fundingStreamPeriodEntityRef);
            sfaCappingGroup.Attributes.Add(DeliverablecappinggroupColumnName, CrmOptionSetFactory.CreateCappingGroupFromString(row.CappingGroupName));
            sfaCappingGroup.Attributes.Add(AllowunderdeliverytobereusedColumnName, row.AllowUnderDeliveryToBeReUsed);
            sfaCappingGroup.Attributes.Add(AllowoverdeliverytobeoffsetColumnName, row.AllowOverDeliveryToBeOffset);

            return sfaCappingGroup;
        }

        protected override void DeleteRowFromCrm(FundingStreamPeriodCappingGroupSheetType row)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                Entity matchingEntity = GetMatchingEntities(crmContext, row).FirstOrDefault();
                
                if (matchingEntity != null)
                {
                    CrmHelper.GetConnection().Delete(CappinggroupsEntityName, matchingEntity.Id);
                }
            }
        }

        protected override IEnumerable<Entity> GetMatchingEntities(XrmServiceContext crmContext, FundingStreamPeriodCappingGroupSheetType row)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria(FundingstreamperiodColumnName, ConditionOperator.Equal, GetFundingStreamPeriodEntityReference(row.FundingStreamPeriod).Id),
                new ColumnValueCriteria(DeliverablecappinggroupColumnName, ConditionOperator.Equal, CrmOptionSetFactory.CreateCappingGroupFromString(row.CappingGroupName).Value)
            };

            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CappinggroupsEntityName, LookupCriteria = columnValues };
            return CrmManager.GetCrmEntities(lookupCriteria, CrmHelper.GetConnection()).ToList();
        }

        private static EntityReference GetFundingStreamPeriodEntityReference(string fundingStreamPeriodCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from fp in crmContext.sfa_fundingstreamperiodSet
                                  where fp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                                  select fp;
                return entityQuery.Single().ToEntityReference();
            }
        }
    }
}