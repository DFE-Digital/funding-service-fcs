namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using System;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using CrossDomain.Integration.Common.Authentication;

    public class OrganisationServiceApiHttpClient : IOrganisationServiceApiHttpClient
    {
        public HttpResponseMessage GetHttpResponseForUkprn(int ukprn)
        {
            const int timeoutSeconds = 60;

            using (HttpClient client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));
                client.Timeout = TimeSpan.FromSeconds(timeoutSeconds);

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                    "Bearer",
                    AzureAuthenticator.GetAuthenticationResult("OrgService"));

                string url = $"{ConfigurationManager.AppSettings["OrgServiceUrl"]}{ukprn}";

                return client.GetAsync(url).Result;
            }
        }
    }
}