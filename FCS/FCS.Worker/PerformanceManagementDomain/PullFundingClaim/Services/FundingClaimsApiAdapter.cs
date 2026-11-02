namespace PerformanceManagementDomain.PullFundingClaim.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net.Http;
    using System.Threading.Tasks;
    using DTOs;
    using Infrastructure;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using Polly;

    public class FundingClaimsApiAdapter : IFundingClaimsApiAdapter
    {
        private static readonly string Url = ConfigurationManager.AppSettings["DCT:FundingClaims:Url"];
        private static readonly string OauthClientId = ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:ClientId"];
        private static readonly string OauthScope = ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:Scope"];
        private static readonly string OauthClientSecret = ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:ClientSecret"];
        private static readonly string OauthTenant = ConfigurationManager.AppSettings["DCT:FundingClaims:Oauth:Tenant"];
        private readonly IHttpService _httpService;
        private readonly IOAuthAccessTokenFactory _authAccessTokenFactory;

        public FundingClaimsApiAdapter(IHttpService httpService, IOAuthAccessTokenFactory authAccessTokenFactory)
        {
            _httpService = httpService;
            _authAccessTokenFactory = authAccessTokenFactory;
        }

        public async Task<IReadOnlyCollection<string>> GetFundingClaimCompletedCollections(DateTime sinceDateTime)
        {
            string iso8601FormatDate = sinceDateTime.ToString("O");

            string content = await CallApi($"{Url}/api/v1.0/fundingclaims/collections/completed?sinceDateTime={iso8601FormatDate}&pageSize={int.MaxValue}");

            JArray collections = content != string.Empty ? JArray.Parse(content) : new JArray();

            IReadOnlyCollection<string> dataCollectionKeys =
                collections
                    .Select(c => c["dataCollectionKey"].ToString())
                    .ToList();

            return dataCollectionKeys;
        }

        public async Task<int> GetCountOfFundingClaimsForCollectionKey(string dataCollectionKey)
        {
            string content = await CallApi($"{Url}/api/v1.0/fundingclaims/submissions/completed/count?dataCollectionKey={dataCollectionKey}");

            return int.Parse(content);
        }

        public async Task<IReadOnlyCollection<FundingClaimApiDto>> GetFundingClaimsForCollectionKey(string dataCollectionKey, int pageNumber)
        {
            string content = await CallApi($"{Url}/api/v1.0/fundingclaims/submissions/completed?dataCollectionKey={dataCollectionKey}&pageNumber={pageNumber}&pageSize={PageSize}");

            IReadOnlyCollection<FundingClaimApiDto> fundingClaims = JsonConvert.DeserializeObject<IReadOnlyCollection<FundingClaimApiDto>>(content);

            return fundingClaims;
        }

        public int PageSize => 100;

        private async Task<string> CallApi(string requestUri)
        {
            return await Policy
                .Handle<Exception>(ex =>
                {
                    if (ex is HttpRequestException && ex.Message.Contains("Unauthorized"))
                    {
                        _authAccessTokenFactory.ClearCache(OauthClientId);
                    }

                    return true;
                })
                .WaitAndRetryAsync(5, _ => TimeSpan.FromSeconds(3))
                .ExecuteAsync(() =>
                {
                    string authorizationToken = _authAccessTokenFactory.GetAccessToken(
                        clientId: OauthClientId, clientSecret: OauthClientSecret, scope: OauthScope, tenant: OauthTenant);

                    return _httpService.GetAsync(authorizationToken, requestUri);
                });
        }
    }
}