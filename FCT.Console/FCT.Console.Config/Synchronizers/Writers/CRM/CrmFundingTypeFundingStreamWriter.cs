namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    /// <summary>
    /// This class is responsible for writing the interect or N:N entity called sfa_fundingtype_fundingstream. It does not fit the pattern
    /// as well as the others
    /// </summary>
    public class CrmFundingTypeFundingStreamWriter : CrmConfigWriter<FundingTypeStreamRelationshipSheetType, sfa_fundingtype_fundingstream>
    {
        const string CrmRelationshipName = "sfa_fundingtype_fundingstream";
        protected override void UpdateMatchingEntity(FundingTypeStreamRelationshipSheetType row, sfa_fundingtype_fundingstream matchingEntity)
        {
           // we don't need to update this one as the two columns form the key
        }

        public override void UpsertRowIntoCrm(FundingTypeStreamRelationshipSheetType row)
        {
            sfa_fundingtype_fundingstream matchingEntity = GetRowWithMatchingKey(row);

            if (matchingEntity == null)
            {
                EntityReferenceCollection fundingStreamsCollection = new EntityReferenceCollection();
                fundingStreamsCollection.Add(GetFundingStreamEntityReference(row.FundingStreamCode));

                Guid? fundingTypeId = GetFundingTypeId(row.FundingTypeCode);
                if (fundingTypeId != null)
                {
                    CrmHelper.GetConnection().Associate(
                        sfa_fundingtype.EntityLogicalName,
                        fundingTypeId.Value,
                        new Relationship(CrmRelationshipName),
                        fundingStreamsCollection);
                }
                else
                {
                    throw new ArgumentException($"The funding type {row.FundingTypeCode} passed in is not supported");
                }
            }
        }

        protected override sfa_fundingtype_fundingstream CreateEntity(FundingTypeStreamRelationshipSheetType row)
        {
            // we can't create in the normal way with a N:N intersect
            return null;
        }

        protected override void DeleteRowFromCrm(FundingTypeStreamRelationshipSheetType row)
        {
            sfa_fundingtype_fundingstream matchingEntity = GetRowWithMatchingKey(row);

            if (matchingEntity != null)
            {
                EntityReferenceCollection fundingStreamsCollection = new EntityReferenceCollection();
                fundingStreamsCollection.Add(GetFundingStreamEntityReference(row.FundingStreamCode));

                Guid? fundingTypeId = GetFundingTypeId(row.FundingTypeCode);
                if (fundingTypeId != null)
                {
                    CrmHelper.GetConnection().Disassociate(sfa_fundingtype.EntityLogicalName,
                        fundingTypeId.Value,
                        new Relationship(CrmRelationshipName),
                        fundingStreamsCollection);
                }
                else
                {
                    throw new ArgumentException($"The funding type {row.FundingTypeCode} passed in is not supported");
                }
            }
        }

        private Guid? GetFundingTypeId(string fundingTypeCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from ft in crmContext.sfa_fundingtypeSet
                                  where ft.sfa_fundingtypecode == fundingTypeCode
                                  select ft;
                return entityQuery.Single().Id;
            }
        }

        private EntityReference GetFundingStreamEntityReference(string fundingStreamCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from fs in crmContext.sfa_fundingstreamSet
                                  where fs.sfa_fundingstreamcode == fundingStreamCode
                                  select fs;
                return entityQuery.Single().ToEntityReference();
            }
        }

        protected override IEnumerable<sfa_fundingtype_fundingstream> GetMatchingEntities(XrmServiceContext crmContext, FundingTypeStreamRelationshipSheetType row)
        {
            return from ftfs in crmContext.sfa_fundingtype_fundingstreamSet
                   join ft in crmContext.sfa_fundingtypeSet on ftfs.sfa_fundingtypeid equals ft.sfa_fundingtypeId
                   join fs in crmContext.sfa_fundingstreamSet on ftfs.sfa_fundingstreamid equals fs.sfa_fundingstreamId
                    where ft.sfa_fundingtypecode == row.FundingTypeCode.ToUpper() &&
                          fs.sfa_fundingstreamcode == row.FundingStreamCode.ToUpper()
                   select ftfs;
        }
    }
}
