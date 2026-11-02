using System.Configuration;
using System.Globalization;
using System.Security.Authentication;
using System.Threading;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    public static class OrgAuthenticationService
    { 
        private static readonly string AadInstance = ConfigurationManager.AppSettings["ida:AADInstance_OrgService"];
        private static readonly string Tenant = ConfigurationManager.AppSettings["ida:Tenant_OrgService"];
        private static readonly string ClientId = ConfigurationManager.AppSettings["ida:ClientId_OrgService"];
        private static readonly string AppKey = ConfigurationManager.AppSettings["ida:AppKey_OrgService"];
        private static readonly string ResourceId = ConfigurationManager.AppSettings["ida:ResourceId_OrgService"];

        public static AuthenticationResult GetAuthenticationResult()
        {
            string authority = string.Format(CultureInfo.InvariantCulture, AadInstance, Tenant);
            AuthenticationContext authContext = new AuthenticationContext(authority);
            ClientCredential clientCredential = new ClientCredential(ClientId, AppKey);

            AuthenticationResult authResult = null;
            int retryCount = 0;
            bool retry;

            do
            {
                retry = false;
                try
                {
                    authResult = authContext.AcquireToken(ResourceId, clientCredential);
                    return authResult;
                }
                catch (AdalException ex)
                {
                    if (ex.ErrorCode == "temporarily_unavailable")
                    {
                        retry = true;
                        retryCount++;
                        Thread.Sleep(3000);
                    }
                }
            }
            while (retry && (retryCount < 3));

            if (authResult == null)
            {
                throw new AuthenticationException("Could not authenticate with the OAUTH2 claims provider after several attempts");
            }

            return authResult;
        }
    }
}
