namespace Operations.Web.Tests.Controller
{
    using System.Net.Http;
    using System.Net.Http.Headers;
    using SFA.FCT.CrossDomain.Integration.Common.Authentication;

    public static class HttpConnectionFactory
    {
        public static HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient();

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthenticator.GetAuthenticationResult("OPS_WEB"));
            return client;
        }
    }
}
