namespace SFA.FCT.Contract.XrmAdapterService.Tests.Utils
{
    using ContractCreateDomain.Implementation.Persistence;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using FCS.Worker.Common.Crm;

    public static class CrmManager
    {
        public static int GetNumContractsInCrmForUser(String ukprn)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_ukprn", ConditionOperator.Equal, ukprn),
                new ColumnValueCriteria("createdon", ConditionOperator.GreaterThan, DateTime.Now.Date)
            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria(){EntityName = CrmEntityName.Contract, LookupCriteria = columnValues};

            return GetCrmEntities(lookupCriteria).Count;
        }

        public static IList<Entity> GetCrmEntities(CrmLookupCriteria lookupCriteria)
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
            var executeMultipleResp = (ExecuteMultipleResponse)CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(executeMultipleReq);

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
