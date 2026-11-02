namespace SFA.FCT.Operations.Integrity.Services
{
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Utils;

    public class RetryOnErrorOrganizationService : OrganizationService
    {
        public RetryOnErrorOrganizationService(CrmConnection crmConnection) : base(crmConnection)
        {
        }

        public override OrganizationResponse Execute(OrganizationRequest request)
        {
            return FunctionRetrier.RetryWhenExceptionThrown(() => base.Execute(request));
        }

        public override EntityCollection RetrieveMultiple(QueryBase query)
        {
            return FunctionRetrier.RetryWhenExceptionThrown(() => base.RetrieveMultiple(query));
        }
    }
}
