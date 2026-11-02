

namespace ApprovedContractsConsistencyChecker.Readers
{
    using System;
    using System.IO;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;
    using System.Xml;
    using System.Net.Http;
    using System.Net.Http.Headers;

    public abstract class FeedReader
    {
        public abstract AzureAuthentication AuthenticationCredentials { get; }

        public abstract string BaseAddress { get; }

        public abstract string PageSpecificUrl { get; }

        public abstract string MostRecentPageUrl { get; }

        public abstract string VendorAtomMediaType { get; }

        public abstract string FeedContentDescription { get; }

        public void Read(Action<string> resultRenderer)
        {
            try
            {
                GetLatestItemsThenWalkLinksToTheStart(resultRenderer).Wait();
            }
            catch (AggregateException aex)
            {
                throw aex.InnerExceptions.First();
            }
        }

        protected async Task GetLatestItemsThenWalkLinksToTheStart(Action<string> resultRenderer)
        {
            var response = await CallEndpointAndReturnResultAsyncForFullUrl(VendorAtomMediaType, BaseAddress + MostRecentPageUrl);
            resultRenderer(response);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));

            SyndicationLink link;
            do
            {
                link = feed.Links.FirstOrDefault(li => li.RelationshipType == "prev-archive");

                if (link != null)
                {
                    response = await CallEndpointAndReturnResultAsyncForFullUrl(VendorAtomMediaType, link.Uri.ToString());
                    resultRenderer(response);
                    feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                }
            }
            while (link != null);
        }

        private async Task<string> CallEndpointAndReturnResultAsyncForFullUrl(string mediaType, string url)
        {
            using (var client = GetAuthorizedHttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(mediaType));
                try
                {
                    var content = await client.GetAsync(url);
                    var foo = await content.Content.ReadAsStringAsync();
                    return foo;
                }
                catch (AggregateException aex)
                {
                    throw aex.InnerExceptions.First();
                }
            }
        }

        private HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", AuthenticationCredentials.GetAuthenticationResult().AccessToken);
            return client;
        }
    }
}
