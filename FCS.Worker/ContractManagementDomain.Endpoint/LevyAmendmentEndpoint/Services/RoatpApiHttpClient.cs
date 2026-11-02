namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using DTOs;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Serialization;

    public class RoatpApiHttpClient : IRoatpApiHttpClient
    {
        private static readonly string BaseAddress = ConfigurationManager.AppSettings["RoatpService:Url"];

        public async Task<IReadOnlyCollection<RoatpProvider>> GetAllProviders()
        {
            using (HttpClient client = new HttpClient())
            {
                using (var response = await client.GetAsync($"{BaseAddress}/api/providers"))
                {
                    HttpResponseMessage result = response;

                    if (result.StatusCode == HttpStatusCode.OK)
                    {
                        IEnumerable<RoatpApiProvider> roatpProviders = 
                            JsonConvert.DeserializeObject<IEnumerable<RoatpApiProvider>>(
                                await result.Content.ReadAsStringAsync().ConfigureAwait(continueOnCapturedContext: false), 
                                new JsonSerializerSettings
                                {
                                    ContractResolver = new CamelCasePropertyNamesContractResolver(),
                                    NullValueHandling = NullValueHandling.Ignore
                                });

                        return
                            roatpProviders.Select(rp => new RoatpProvider(rp.Ukprn.ToString(), rp.ApplicationType)).ToList();
                    }

                    throw new Exception($"The ROATP API returned status code: {result.StatusCode}");
                }
            }
        }

        private class RoatpApiProvider
        {
            public long Ukprn { get; set; }

            public string ApplicationType { get; set; }
        }
    }
}