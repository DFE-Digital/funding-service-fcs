namespace FCT.Console.Config.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using MoreLinq;

    public static class CrmTableCleaner
    {
        public static void DeleteAllRows(string logicalName, IOrganizationService connection)
        {
            GetCrmEntities(logicalName, connection)
                .ForEach(e => connection.Delete(logicalName, e.Id));
        }

        private static IReadOnlyCollection<Entity> GetCrmEntities(string entityLogicalName, IOrganizationService organizationService)
        {
            var retrieveMultipleContractRequest = new RetrieveMultipleRequest();
            var contractQuery = new QueryExpression
            {
                EntityName = entityLogicalName,
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

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
    }
}