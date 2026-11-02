namespace CrossDomain.XrmDevelopmentLibrary.WorkflowsNS.Utilities
{
    using Microsoft.IdentityModel.Clients.ActiveDirectory;
    using System.Security.Authentication;
    using System.Threading;
   

    public static class AzureAuthentication
    {
        public static AuthenticationResult GetAuthenticationResult(string aadInstance, string tenant, string clientId,
            string appKey, string resourceId)
        {
            string authority = string.Format(aadInstance,
                tenant);
            AuthenticationContext authContext = new AuthenticationContext(authority);
            ClientCredential clientCredential = new ClientCredential(clientId,
                appKey);

            AuthenticationResult authResult = null;
            int retryCount = 0;
            bool retry;

            do
            {
                retry = false;
                try
                {
                    authResult = authContext.AcquireToken(resourceId,
                        clientCredential);
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
            } while (retry && (retryCount < 3));

            if (authResult == null)
            {
                throw new AuthenticationException(
                    "Could not authenticate with the OAUTH2 claims provider after several attempts");
            }

            return authResult;
        }
    }
}
