namespace ContractRequestDomain.Cfs.Detail.Services
{
    using System;
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using ContractRequestDomain.Cfs.Infrastructure;

    public class AllocationDetailService : IAllocationDetailService
    {
        private const string DetailApi = "/api/v1/allocations/{0}/{1}";

        public async Task<Allocation> GetAllocationDetail(string allocationId, int version)
        {
            string formattedUrl = string.Format(DetailApi, allocationId, version);

            string oAuthToken = GetOAuthToken();

            using (HttpClient httpClient = new HttpClient
            {
                BaseAddress = new Uri(GetRootUrl()),
            })
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", oAuthToken);

                HttpResponseMessage httpResponseMessage = await httpClient.GetAsync(formattedUrl);
                if (httpResponseMessage.StatusCode == HttpStatusCode.OK)
                {
                    string jsonAllocation = await httpResponseMessage.Content.ReadAsStringAsync();

                    return CfsAllocationTransfomer.TransformToAllocation(jsonAllocation);
                }
              
                throw new ArgumentException($"CFS Detail Service has not worked for allocationId: {allocationId}, version: {version}, httpStatusCode: {httpResponseMessage.StatusCode}");
            }
        }

        private string GetRootUrl()
        {
            return ConfigurationManager.AppSettings["Cfs:RootUrl"];
        }

        private static string GetOAuthToken()
        {
            string claimsProviderUrl = ConfigurationManager.AppSettings["Cfs:ClaimsProvider"];
            string tenantId = ConfigurationManager.AppSettings["Cfs:TenantId"];
            string clientId = ConfigurationManager.AppSettings["Cfs:ClientId"];
            string clientSecret = ConfigurationManager.AppSettings["Cfs:ClientSecret"];
            string resource = ConfigurationManager.AppSettings["Cfs:Resource"];

            return AuthenticationTokenProvider.GetToken(
                claimsProviderUrl: claimsProviderUrl,
                tenantId: tenantId,
                clientId: clientId,
                clientSecret: clientSecret,
                resource: resource);
        }
    }
}
