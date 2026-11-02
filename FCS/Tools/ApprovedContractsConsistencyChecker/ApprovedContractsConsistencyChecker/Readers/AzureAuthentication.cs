
namespace ApprovedContractsConsistencyChecker.Readers
{
    using System.Security.Authentication;
    using System.Threading;
    using Microsoft.IdentityModel.Clients.ActiveDirectory;

    public class AzureAuthentication
    {
        private readonly string _aadInstance;
        private readonly string _tenant;
        private readonly string _clientId;
        private readonly string _appKey;
        private readonly string _resourceId;

        public AzureAuthentication(string aadInstance, string tenant, string clientId, string appKey, string resourceId)
        {
            _aadInstance = aadInstance;
            _tenant = tenant;
            _clientId = clientId;
            _appKey = appKey;
            _resourceId = resourceId;
        }

        public AuthenticationResult GetAuthenticationResult()
        {
            string authority = string.Format(_aadInstance, _tenant);
            AuthenticationContext authContext = new AuthenticationContext(authority);
            ClientCredential clientCredential = new ClientCredential(_clientId, _appKey);

            AuthenticationResult authResult = null;
            int retryCount = 0;
            bool retry;

            do
            {
                retry = false;
                try
                {
                    authResult = authContext.AcquireToken(_resourceId, clientCredential);
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
