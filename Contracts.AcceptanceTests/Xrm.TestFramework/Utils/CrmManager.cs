namespace SFA.FCT.Xrm.TestFramework.Utils
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Configuration;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Metadata;
    using Microsoft.Xrm.Sdk.Query;

    public class CrmManager
    {
        private string _userName;

        /// <summary>
        /// Not used any more
        /// </summary>
        /// <param name="userName"></param>
        public CrmManager(string userName)
        {
            _userName = userName;
        }

        public CrmManager()
        {
        }

        public void Delete(Entity entity)
        {
            ConnectAsUser().Delete(entity);
        }

        public List<Entity> GetCrmEntities(CrmLookupCriteria lookupCriteria)
        {
            var contractQuery = new QueryExpression
            {
                EntityName = lookupCriteria.EntityName,
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            contractQuery.Criteria = new FilterExpression();
            foreach (ColumnValueCriteria criteria in lookupCriteria.LookupCriteria)
            {
                contractQuery.Criteria.AddCondition(criteria.ColumnName, criteria.ConditionOperator, criteria.Values);
            }

            foreach (var linkEntity in lookupCriteria.LinkEntities)
            {
                contractQuery.LinkEntities.Add(linkEntity);
            }

            var rmr = new RetrieveMultipleRequest();

            rmr.Query = contractQuery;
            var executeMultipleResp = (RetrieveMultipleResponse)ConnectAsUser().Execute(rmr);
            var refEntityList = new List<Entity>();
            refEntityList.AddRange(executeMultipleResp.EntityCollection.Entities);
            AddRelatedEntitiesToCollection(refEntityList, lookupCriteria);
            return refEntityList;
        }

        public int? GetOptionsetValue(string optionsetName, string label)
        {
            int? optionsetValue = null;
            var retrieveOptionSetRequest = new RetrieveOptionSetRequest
            {
                Name = optionsetName
            };

            // Execute the request.
            RetrieveOptionSetResponse retrieveOptionSetResponse =
                (RetrieveOptionSetResponse)ConnectAsUser().Execute(retrieveOptionSetRequest);

            // Access the retrieved OptionSetMetadata.
            OptionSetMetadata retrievedOptionSetMetadata = (OptionSetMetadata)retrieveOptionSetResponse.OptionSetMetadata;

            // Get the current options list for the retrieved attribute.
            OptionMetadata[] optionList = retrievedOptionSetMetadata.Options.ToArray();
            foreach (OptionMetadata optionMetadata in optionList)
            {
                if (optionMetadata.Label.LocalizedLabels.First().Label == label)
                {
                    optionsetValue = optionMetadata.Value;
                    break;
                }
            }

            return optionsetValue;
        }

        public CrmOrganisationService ConnectAsUser()
        {
            return new CrmOrganisationService(OrganizationServiceFactory.GetOrganizationService());
        }

        private void AddRelatedEntitiesToCollection(List<Entity> entities, CrmLookupCriteria lookupCriteria)
        {
            if (lookupCriteria.RelationshipDetail != null)
            {
                // create relationshipQueryCollection Object
                RelationshipQueryCollection relatedEntitesQueryCollection = new RelationshipQueryCollection();
                var query = new QueryExpression
                {
                    EntityName = lookupCriteria.RelationshipDetail.EntityName,
                    ColumnSet = new ColumnSet(true),
                    Criteria = new FilterExpression()
                };

                Relationship relationship = new Relationship();
                relationship.SchemaName = lookupCriteria.RelationshipDetail.RelationshipName;

                // Add the relation and query to the RelationshipQueryCollection
                relatedEntitesQueryCollection.Add(relationship, query);

                foreach (var entity in entities)
                {
                    RetrieveRequest request = new RetrieveRequest();
                    request.RelatedEntitiesQuery = relatedEntitesQueryCollection;
                    request.ColumnSet = new ColumnSet();
                    request.Target = new EntityReference(lookupCriteria.EntityName, entity.Id);

                    RetrieveResponse response = (RetrieveResponse)ConnectAsUser().Execute(request);
                    entity.RelatedEntities.Add(relationship, response.Entity.RelatedEntities[relationship]);
                }
            }
        }

        private string GetValueFromSettings(string key)
        {
            string settingsVal;
            try
            {
                var testAppSettingsSection = ConfigurationManager.GetSection("applicationSettings/SFA.FCT.Contracts.AcceptanceTests.Properties.Settings") as ClientSettingsSection;
                if (testAppSettingsSection != null)
                {
                    settingsVal = testAppSettingsSection.Settings.Get(key).Value.ValueXml.InnerText;
                }
                else
                {
                    throw new Exception("The App Settings does not contain - applicationSettings/SFA.FCT.Contracts.AcceptanceTests.Properties.Settings");
                }
            }
            catch (Exception)
            {
                throw new Exception("The App Settings does not contain - " + key);
            }

            return settingsVal;
        }
    }
}