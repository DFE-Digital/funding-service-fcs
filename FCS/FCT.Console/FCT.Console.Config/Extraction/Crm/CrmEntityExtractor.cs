namespace FCT.Console.Config.Extraction.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using Infrastructure;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Metadata;
    using SFA.FCT.CrossDomain.Integration.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers.CRM;

    public static class CrmEntityExtractor
    {
        public static string ExtractDataAsCsv(string crmEntityName)
        {
            CrmEntityRows crmEntityRows = GetEntities(crmEntityName);

            return CrmEntityTransformer.TransformEntitiesToCsv(crmEntityRows);
        }

        private static CrmEntityRows GetEntities(string crmEntityName)
        {
            var columnValues = new List<ColumnValueCriteria>();
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = crmEntityName, LookupCriteria = columnValues };
                
            CrmEntityRows crmEntityRows = new CrmEntityRows(
                entities: CrmManager.GetCrmEntities(lookupCriteria, CrmHelper.GetConnection()).ToList(),
                columnLabels: GetAttributes(crmEntityName,
                new XrmServiceContext(CrmConnectionFactory.GetOrganizationService())));

            return crmEntityRows;
        }

        public static Dictionary<string, string> GetAttributes(string entityName, XrmServiceContext xrm)
        {
            Dictionary<string, string> attributesData = new Dictionary<string, string>();

            RetrieveEntityRequest metaDataRequest = new RetrieveEntityRequest();
            RetrieveEntityResponse metaDataResponse = new RetrieveEntityResponse();
            metaDataRequest.EntityFilters = EntityFilters.Attributes;
            metaDataRequest.LogicalName = entityName;
            metaDataResponse = (RetrieveEntityResponse)xrm.Execute(metaDataRequest);

            foreach (AttributeMetadata a in metaDataResponse.EntityMetadata.Attributes)
            {
                //if more than one label for said attribute, get the one matching the languade code we want...
                if (a.DisplayName.LocalizedLabels.Count() > 1)
                    attributesData.Add(a.LogicalName, a.DisplayName.LocalizedLabels.SingleOrDefault().Label);

                //else, get the only one available regardless of languade code...
                if (a.DisplayName.LocalizedLabels.Count() == 1)
                    attributesData.Add(a.LogicalName, a.DisplayName.LocalizedLabels[0].Label);
            }

            return attributesData;
        }
    }
}