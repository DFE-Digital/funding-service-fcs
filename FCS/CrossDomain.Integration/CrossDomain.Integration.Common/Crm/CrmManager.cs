namespace SFA.FCT.CrossDomain.Integration.Common.Crm
{
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public static class CrmManager
    {
        public const string ContractDeliverablePeriodEntityName = "sfa_contractdeliverableperiod";
       
        public static IList<Entity> GetCrmEntities(CrmLookupCriteria lookupCriteria, IOrganizationService organizationService)
        {
            var retrieveMultipleContractRequest = new RetrieveMultipleRequest();
            var contractQuery = new QueryExpression
            {
                EntityName = lookupCriteria.EntityName,
                ColumnSet = new ColumnSet(true)
            };

            contractQuery.Criteria = new FilterExpression();
            foreach (ColumnValueCriteria criteria in lookupCriteria.LookupCriteria)
            {
                contractQuery.Criteria.AddCondition(criteria.ColumnName, criteria.ConditionOperator, criteria.Value);
            }

            var executeMultipleReq = new ExecuteMultipleRequest()
            {
                Settings = new ExecuteMultipleSettings()
                {
                    ContinueOnError = false,
                    ReturnResponses = true
                },
                Requests = new OrganizationRequestCollection()
            };
            executeMultipleReq.Requests.Add(retrieveMultipleContractRequest);
            retrieveMultipleContractRequest.Query = contractQuery;
            var executeMultipleResp = (ExecuteMultipleResponse)organizationService.Execute(executeMultipleReq);

            var refEntityList = new List<Entity>();
            foreach (var r in executeMultipleResp.Responses.Where(r => r.Fault == null))
            {
                refEntityList.AddRange(((RetrieveMultipleResponse)r.Response).EntityCollection.Entities);
            }

            return refEntityList;
        }

        public static void DeleteEntity(IOrganizationService organizationService, string entityName, Guid primaryKey)
        {
            organizationService.Delete(entityName, primaryKey);
        }
    }
}
