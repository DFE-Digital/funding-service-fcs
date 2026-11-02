namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using Dto;
    using Infrastructure;
    using Microsoft.Extensions.Configuration;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class FundingNotificationApi : IFundingNotificationApi
    {
        private const int PageSize = 500;
        private readonly IConfigurationRoot _configuration;
        private static readonly HttpClient HttpClient = new HttpClient();

        public FundingNotificationApi(IConfigurationRoot configuration)
        {
            _configuration = configuration;
        }

        public async Task<CfsLatestPageData> GetLatestPageData()
        {
            string path = $"api/v4/contracts/funding/notifications?groupingreasons=Contracting&pageSize={PageSize}";
            
            string url = GetFullUrl(path);

            string json = await GetContentFromUrl(url);

            string prevLink = CfsAtomParser.GetPrevLink(json);

            int lastButOnePageNumber = 0;
            if (prevLink != null)
            {
                lastButOnePageNumber = CfsAtomParser.GetPageNumberFromLink(prevLink);
            }

            var latestPageNumber = lastButOnePageNumber + 1;
            var atomItems = CfsAtomParser.GetAtomItems(json);
            atomItems.ToList().ForEach(ai =>
            {
                EnrichAtomItem(ai, latestPageNumber);
            });

            return new CfsLatestPageData(atomItems.ToArray(), latestPageNumber);
        }

        public async Task<IReadOnlyCollection<AtomItem>> GetPage(int pageNumber)
        {
            string path = $"api/v4/contracts/funding/notifications/{pageNumber}?groupingreasons=Contracting&pageSize={PageSize}";

            string url = GetFullUrl(path);

            string json = await GetContentFromUrl(url);

            var atomItems = CfsAtomParser.GetAtomItems(json);

            atomItems.ToList().ForEach(ai =>
            {
                EnrichAtomItem(ai, pageNumber);
            });

            return atomItems;
        }

        public async Task<ProviderFundingAllocationApiDto> GetProviderFundingAllocation(string providerFundingId)
        {
            string path = $"api/v4/contracts/funding/provider/{providerFundingId}";
            string url = GetFullUrl(path);

            string json = await GetContentFromUrl(url);

            return CfsAtomParser.GetProviderFundingAllocationApiDto(json);
        }

        private static void EnrichAtomItem(AtomItem atomItem, int pageNumber)
        {
            atomItem.PageNumber = pageNumber;
        }

        private string GetFullUrl(string path)
        {
            string rootUrl = _configuration["Cfs:RootUrl"];
            
            return $"{rootUrl}/{path}";            
        }

        private async Task<string> GetContentFromUrl(string url)
        {
            var response = await GetResponseFromUrl(url);

            response.EnsureSuccessStatusCode();

            return await response.Content.ReadAsStringAsync();
        }

        private async Task<HttpResponseMessage> GetResponseFromUrl(string url)
        {
            var accessToken = OAuthAccessTokenFactory.GetAccessToken(_configuration, OAuthAccessTokenFactory.SecureApplication.Cfs);
            HttpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            return await HttpClient.GetAsync(url);
        }
    }
}
