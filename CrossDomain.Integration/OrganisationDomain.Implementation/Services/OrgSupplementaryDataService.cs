namespace OrganisationDomain.Implementation.Services
{
    using Common;
    using Integration.Entities;
    using Newtonsoft.Json;

    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using System.IO;

    public class OrgSupplementaryDataService : IOrgSupplementaryDataService
    {
        private readonly ILogger _logger;
        private const string AadInstance = "https://login.microsoftonline.com/{0}";
        private static readonly string OauthTenant = ConfigurationManager.AppSettings["UkrlpApi:Tenant"];        
        private static readonly string clientId = ConfigurationManager.AppSettings["UkrlpApi:ClientId"];
        private static readonly string clientSecret = ConfigurationManager.AppSettings["UkrlpApi:ClientSecret"];
        private static readonly string scope = ConfigurationManager.AppSettings["UkrlpApi:Scope"];
        private static readonly string subscriptionKey = ConfigurationManager.AppSettings["UkrlpApi:Subscription"];
        private static readonly string ukrlpBaseUrl = ConfigurationManager.AppSettings["UkrlpService:Url"];

        public OrgSupplementaryDataService(ILogger logger)
        {
            _logger = logger;
        }

        public OrgSupplementaryDataServiceResult GetDataForUkprn1(int ukprn)
        {
            return GetDataForUkprn(ukprn)
                .GetAwaiter()
                .GetResult();
        }
        public async Task<OrgSupplementaryDataServiceResult> GetDataForUkprn(int ukprn)
        {
            try
            {
                var url = $"{ukrlpBaseUrl}/api/providers?UKPRNS={ukprn}";

                var token = await GetAccessTokenAsync();

                var providers = await CallApi(url, token);

                if (providers == null || !providers.Any())
                {
                    _logger.LogError(OrganisationDomainEventLoggingId.ProviderNotFoundInUkrlpService, "Provider not found for ukprn: {0}", 1);
                    return new OrgSupplementaryDataServiceResult(null, false);
                }

                return providers.ToOrgSupplementaryDataServiceResult();
            }
            catch (Exception ex)
            {
                _logger.LogError(OrganisationDomainEventLoggingId.ErrorCallingUkrlpService, "Error calling UKRLP API for ukprn {0}: {1}", ukprn, ex.Message);
                return new OrgSupplementaryDataServiceResult(null, false);
            }
        }


        public IReadOnlyCollection<OrgSupplementaryData> GetSupplementaryDataChanges1(int numberOfDaysToCheck = -7)
        {
            return GetSupplementaryDataChanges(numberOfDaysToCheck)
                .GetAwaiter()
                .GetResult();
        }

        public async Task<IReadOnlyCollection<OrgSupplementaryData>> GetSupplementaryDataChanges(int numberOfDaysToCheck = -7)
        {
            try
            {
                var updatedSince = DateTime.UtcNow.AddDays(numberOfDaysToCheck).ToString("yyyy-MM-dd");

                var url = $"{ukrlpBaseUrl}/api/providers" +
                          $"?UpdatedSince={updatedSince}&UKPRNStatus=active";
                var token = await GetAccessTokenAsync();

                var providers = await CallApi(url, token);

                return providers.ToOrgSupplementaryDataCollection();
            }
            catch (Exception ex)
            {
                _logger.LogError(OrganisationDomainEventLoggingId.ErrorCallingUkrlpService, "Error calling UKRLP API: {0}", ex.Message);
                return new List<OrgSupplementaryData>();
            }
        }
        private async Task<List<ProviderRecord>> CallApi(string url, string token)
        {
            var results = new List<ProviderRecord>();

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", token);
                client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", subscriptionKey);
                client.DefaultRequestHeaders.Add("api-Version", "1");
                client.DefaultRequestHeaders.Add("Accept", "application/x-ndjson");

                var response = await client.GetAsync(url);
                response.EnsureSuccessStatusCode();

                using (var stream = await response.Content.ReadAsStreamAsync())
                using (var reader = new StreamReader(stream))
                {
                    string line;

                    while ((line = await reader.ReadLineAsync()) != null)
                    {
                        if (string.IsNullOrWhiteSpace(line))
                            continue;

                        try
                        {
                            var obj = JsonConvert.DeserializeObject<UkrlpApiResponse>(line);

                            if (obj?.MatchingProviderRecords != null)
                            {
                                results.AddRange(obj.MatchingProviderRecords);
                            }
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(OrganisationDomainEventLoggingId.ErrorCallingUkrlpService, "Failed to parse record: {0}", ex.Message);
                        }
                    }
                }
            }

            return results;
        }

        private async Task<string> GetAccessTokenAsync()
        {
            var authority = string.Format(AadInstance, OauthTenant);
            var client = new HttpClient();
            var request = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("client_secret", clientSecret),
                new KeyValuePair<string, string>("scope", scope)
            });

            var response = await client.PostAsync(authority + "/oauth2/v2.0/token", request);
            response.EnsureSuccessStatusCode();

            var json = await response.Content.ReadAsStringAsync();
            dynamic token = JsonConvert.DeserializeObject(json);

            return token.access_token;
        }
    }
}
