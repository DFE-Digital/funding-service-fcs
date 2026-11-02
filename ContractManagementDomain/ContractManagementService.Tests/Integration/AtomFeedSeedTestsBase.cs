using ContractManagement.DataStore;
using ContractManagement.DataStore.Repositories;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;
    using System.Xml;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Common.PagedStorage;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Utils;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.AspNetCore;
    using Microsoft.AspNetCore.Hosting;
    using Microsoft.AspNetCore.TestHost;

    public abstract class AtomFeedSeedTestsBase
    {
        protected static IServiceProvider Container { get; set; }

        protected abstract string LastPageUrl { get; }

        protected abstract string AtomMediaType { get; }

        private static string BaseAddress
        {
            get { return ConfigurationManager.AppSettings["ContractManagementServiceUrl"]; }
        }

        public async Task ShouldRunSeedAndDataOnFeedShouldContainSomeSeedData<T>(int totalExpectedRows, IPagedStorageSeed<contract> seed)
        {
            var runner = new AtomFeedSeedRunner(
                Container.GetService<ILogger>(),
                Container.GetService<IApprovedContractAtomItemRepository>());

            runner.Execute(seed.GetDataEnumerable());
            var totalFeedItems = await GetNumberOfItemsInFeed(AtomMediaType, LastPageUrl);

            // to test for the presence of "some" items is weak but much of the contract data
            // encountered in the pipeline environments is invalid or duplicated and cannot be inserted (correctly)
            // preventing us asserting that all attempted items are in the repository after a seed
            Assert.IsTrue(totalFeedItems > 0 || totalExpectedRows == 0, "No items are in retrieved feed");
        }

        protected static void SetupIoC()
        {
            var server = new TestServer(
                WebHost.CreateDefaultBuilder()
                    .UseStartup<Startup>()
            );
            Container = server.Host.Services;
        }

        private static async Task<string> CallEndpointAndReturnResultAsync(string mediaType, string url)
        {
            return await CallEndpointAndReturnResultAsyncForFullUrl(mediaType, BaseAddress + url);
        }

        private static async Task<string> CallEndpointAndReturnResultAsyncForFullUrl(string mediaType, string url)
        {
            using (var client = GetAuthorizedHttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(mediaType));
                return await client.GetAsync(url).Result.Content.ReadAsStringAsync();
            }
        }

        private static HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
            return client;
        }

        private static async Task<int> GetNumberOfItemsInFeed(string atomMediaType, string latestPageUrl)
        {
            var response = await CallEndpointAndReturnResultAsync(atomMediaType, latestPageUrl);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            var numItems = feed.Items.Count();

            SyndicationLink link;
            do
            {
                link = feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.PreviousRelationship);

                if (link != null)
                {
                    // now call end point again
                    response = CallEndpointAndReturnResultAsyncForFullUrl(atomMediaType, link.Uri.ToString()).Result;

                    feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                    numItems += feed.Items.Count();
                }
            }
            while (link != null);

            return numItems;
        }
    }
}
