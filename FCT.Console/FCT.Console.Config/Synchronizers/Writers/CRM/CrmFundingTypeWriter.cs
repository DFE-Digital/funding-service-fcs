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

    public class CrmFundingTypeWriter : CrmConfigWriter<FundingTypeSheetType, Entity>
    {
        private const string FundingType = "sfa_fundingtype";
        private const string AgencyId = "sfa_agencyid";
        private const string AllowMultipleContracts = "sfa_allowmultiplecontracts";
        private const string ContractReferencePrefix = "sfa_contractreferenceprefix";
        private const string DocumentationNotRequired = "sfa_documentationnotrequired";
        private const string FundingTypeCode = "sfa_fundingtypecode";
        private const string Name = "sfa_name";

        protected override Entity CreateEntity(FundingTypeSheetType row)
        {
            var agencyEntityRef = GetAgencyEntityReference(row.AgencyCode);

            Entity sfa_fundingtype = new Entity(FundingType);
            sfa_fundingtype.Attributes.Add(Name, row.FundingTypeName);
            sfa_fundingtype.Attributes.Add(FundingTypeCode, row.FundingTypeCode);
            sfa_fundingtype.Attributes.Add(AgencyId, agencyEntityRef);
            sfa_fundingtype.Attributes.Add(ContractReferencePrefix, row.ContractReferencePrefix);
            sfa_fundingtype.Attributes.Add(AllowMultipleContracts, row.AllowMultipleContracts);
            sfa_fundingtype.Attributes.Add(DocumentationNotRequired, !row.DocumentationRequired);

            return sfa_fundingtype;
        }

        protected override void UpdateMatchingEntity(FundingTypeSheetType row, Entity matchingEntity)
        {
            var agencyEntityRef = GetAgencyEntityReference(row.AgencyCode);

            matchingEntity[Name] = row.FundingTypeName;
            matchingEntity[FundingTypeCode] = row.FundingTypeCode;
            matchingEntity[AgencyId] = agencyEntityRef;
            matchingEntity[ContractReferencePrefix] = row.ContractReferencePrefix;
            matchingEntity[AllowMultipleContracts] = row.AllowMultipleContracts;
            matchingEntity[DocumentationNotRequired] = !row.DocumentationRequired;
        }

        protected override void DeleteRowFromCrm(FundingTypeSheetType row)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                Entity matchingEntity = GetMatchingEntities(crmContext, row).FirstOrDefault();

                if (matchingEntity != null)
                {
                    CrmHelper.GetConnection().Delete(FundingType, matchingEntity.Id);
                }
            }
        }

        protected override IEnumerable<Entity> GetMatchingEntities(XrmServiceContext crmContext, FundingTypeSheetType row)
        {
            var columnValues = new List<ColumnValueCriteria>()
                        {
                            new ColumnValueCriteria(FundingTypeCode, ConditionOperator.Equal, row.FundingTypeCode)
                        };

            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = FundingType, LookupCriteria = columnValues };
            return CrmManager.GetCrmEntities(lookupCriteria, CrmHelper.GetConnection()).ToList();
        }

        private EntityReference GetAgencyEntityReference(int agencyCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from fp in crmContext.sfa_agencySet
                                  where fp.sfa_agencycode == agencyCode.ToString() 
                                  select fp;
                return entityQuery.Single().ToEntityReference();
            }
        }

    }
}