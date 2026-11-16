namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.Services
{
    using System;
    using System.Net;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using ContractManagement.DataStore.Model;
    using Dtos;
    using Newtonsoft.Json;
    using System.Configuration;
    using Polly;

    public class DasEventsApiAdapter : IDasEventsApiAdapter
    {
        private readonly string _baseAddress;
        private readonly string _resourceId;
        private readonly string _clientId;
        private readonly string _appKey;
        private readonly IOAuthAccessTokenFactory _oAuthAccessTokenFactory;

        public DasEventsApiAdapter(IOAuthAccessTokenFactory oAuthAccessTokenFactory)
        {
            _oAuthAccessTokenFactory = oAuthAccessTokenFactory;

            System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

            _baseAddress = ConfigurationManager.AppSettings["DasEngagements.BaseUrl"];
            _resourceId = ConfigurationManager.AppSettings["DasEngagements.ResourceId"];
            _clientId = ConfigurationManager.AppSettings["DasEngagements.ClientId"];
            _appKey = ConfigurationManager.AppSettings["DasEngagements.SecretKey"];
        }

        public IReadOnlyCollection<EngagementEvent> GetEngagementEventsAfterId(long fromEventId, int pageSize)
        {
            var url = GetEventsUrl(fromEventId, pageSize);

            var responseContent = Policy
                    .Handle<HttpRequestException>(httpEx =>
                    {
                        if (httpEx.Message.Contains("Unauthorized"))
                        {
                            // just in case the token has expired let's have another go with a fresh token
                            _oAuthAccessTokenFactory.ClearCache();
                        }

                        return true;
                    })
                    .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                    .Execute(() => CallApi(url));

            var apprenticeshipEventViews = JsonConvert.DeserializeObject<List<AgreementEventView>>(responseContent);

            return apprenticeshipEventViews.Select(e => new EngagementEvent(e.Id, e.Event, e.ProviderId)).ToList();
        }

        public string BaseUrl => _baseAddress;

        private string CallApi(string url)
        {
            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", GetBearerToken());
                var response = httpClient.GetAsync(url).Result;

                response.EnsureSuccessStatusCode();

                return response.Content.ReadAsStringAsync().Result;
            }
        }

        private string GetBearerToken()
        {
            return _oAuthAccessTokenFactory.GetAccessToken(_clientId, _appKey, _resourceId);
        }

        private string GetEventsUrl(long sinceEventId, int pageSize)
        {
            return $"{_baseAddress}api/v1/Organisation/engagements?sinceEventId={sinceEventId}&pageSize={pageSize}&pageNumber=1";
        }
    }
}
