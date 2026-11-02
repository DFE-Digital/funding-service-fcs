namespace Operations.Web.Checkers
{
    using System;
    using System.Threading.Tasks;
    using Dtos;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;

    public class CrmCheckAvailability :  ICheckAvailability
    {
        public string ServiceName => "Crm";

        public Task<AvailabilityCheckResult> GetCheckResult() 
        {
            const string crmEntityName = "sfa_fundingtype";
            try
            {
                IOrganizationService orgService = CrmConnectionFactory.GetOrganizationService();
                QueryExpression query = new QueryExpression
                {
                    EntityName = crmEntityName,
                    ColumnSet = new ColumnSet(true),
                    Criteria = new FilterExpression()
                };

                if (!CanExecuteQuery(query, orgService))
                {
                    throw new InvalidOperationException($"Cannot connect to CRM entity {crmEntityName}");
                };
            }
            catch (Exception e)
            {
                return Task.FromResult(new AvailabilityCheckResult(ServiceName, false)
                {
                    Details = e.Message
                });
            }

            return Task.FromResult(new AvailabilityCheckResult(ServiceName,true));
        }

        private bool CanExecuteQuery(QueryExpression query, IOrganizationService orgService)
        {
            RetrieveMultipleRequest rmr = new RetrieveMultipleRequest {Query = query};

            ExecuteMultipleRequest emr = new ExecuteMultipleRequest
            {
                Requests = new OrganizationRequestCollection {rmr},
                Settings = new ExecuteMultipleSettings {ReturnResponses = true}
            };

            ExecuteMultipleResponse xmr = (ExecuteMultipleResponse)orgService.Execute(emr);

            return !xmr.IsFaulted && xmr.Responses.Count > 0;
        }
    }
}