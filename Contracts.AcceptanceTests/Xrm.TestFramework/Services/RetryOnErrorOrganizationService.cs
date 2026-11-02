namespace SFA.FCT.Xrm.TestFramework.Services
{
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
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
    }
}
