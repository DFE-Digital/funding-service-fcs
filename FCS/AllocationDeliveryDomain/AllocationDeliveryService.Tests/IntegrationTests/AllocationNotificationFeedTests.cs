namespace AllocationDeliveryService.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity.Validation;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;
    using System.Xml;
    using System.Xml.Serialization;
    using ContractManagementService.DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Test.Utils;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class AllocationNotificationFeedTests
    {
        private const string PreviousLinkType = "prev-archive";
        private const string NextLinkType = "next-archive";
        private const string SelfLinkType = "self";
        private const string CurrentLinkType = "current";
        private static readonly TimeSpan MaxCacheTimespan = new TimeSpan(365, 0, 0, 0);
        private readonly string _endpointUrl;

        public AllocationNotificationFeedTests()
        {
            var builder = new UriBuilder(new AppConfiguration()["ContractManagementServiceUrl"]);
            builder.Path = "/api/allocation-delivery/monitoring/notifications/all";
            _endpointUrl = builder.Uri.ToString();//.Replace(":80/", "/");
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public async Task AllocationNotificationFeed_AllAllocations_ShouldReturn1ItemForEachCategoryTest()
        {
            try
            {
                // Arrange
                var entry1 = CreateAllocationDeliveryEntry(
                    AllocationDeliveryEntryCategory.NewContractAllocationApproved, DateTime.Now.AddSeconds(-3));
                var entry2 =
                    CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.AmendedContractAllocationApproved,
                        DateTime.Now.AddSeconds(-2));
                var entry3 =
                    CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.ContractAllocationActualsReceived,
                        DateTime.Now.AddSeconds(-1));
                var entry4 =
                    CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived,
                        DateTime.Now);

                AllocationDeliveryEntrySetup.ClearAllocationDeliveryEntryAndData();
                AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(entry1, new AllocationDeliveryPerformance());
                AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(entry2, new AllocationDeliveryPerformance());
                AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(entry3, new AllocationDeliveryPerformance());
                AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(entry4, new AllocationDeliveryPerformance());
                
                // Act
                var feed = await RetrieveFeed(_endpointUrl, true, null);
                ValidateAtomFeedHeader(feed, entry4.CreatedDate);
                Assert.AreEqual(4, feed.Items.Count());
                var feedItems = feed.Items.ToList();
                ValidateFeedItem(feedItems[0], entry1);
                ValidateFeedItem(feedItems[1], entry2);
                ValidateFeedItem(feedItems[2], entry3);
                ValidateFeedItem(feedItems[3], entry4);
            }
            catch (DbEntityValidationException e)
            {
                Assert.Fail(e.Message);
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public async Task AllocationNotificationFeed_PagingShouldReturn2PagesTest()
        {
            var entries = new List<AllocationDeliveryEntry>();
            try
            {
                // Arrange
                AllocationDeliveryEntrySetup.ClearAllocationDeliveryEntryAndData();

                for (int i = 0; i < 21; i++)
                {
                    var entry =
                        CreateAllocationDeliveryEntry(
                            AllocationDeliveryEntryCategory.NewContractAllocationApproved,
                            DateTime.Now.AddSeconds(i));
                    AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(entry, new AllocationDeliveryPerformance());
                    entries.Add(entry);
                }

            }
            catch (DbEntityValidationException ex)
            {
                Assert.Fail(ex.InnerException.Message);
            }

            entries = entries.OrderBy(e => e.CreatedDate).ToList();

            // Act & Assert
            var headUpdatesFeed = await RetrieveFeed(_endpointUrl, true, null);
            ValidateAtomFeedHeader(headUpdatesFeed, entries.Last().CreatedDate);
            Assert.AreEqual(1, headUpdatesFeed.Items.Count());
            ValidateFeedItem(headUpdatesFeed.Items.ElementAt(0), entries.Last());
            // check navgation links
            CheckLink(headUpdatesFeed, SelfLinkType, _endpointUrl);
            CheckLink(headUpdatesFeed, CurrentLinkType, null);
            CheckLink(headUpdatesFeed, PreviousLinkType, GetPageUrl(2));
            CheckLink(headUpdatesFeed, NextLinkType, null);

            // Retrieve page 2
            var page1Feed = await RetrieveFeed(GetPageUrl(2), true, null);
            var expectedPage2Entries = entries.Skip(10).Take(10).ToList();
            ValidateAtomFeedHeader(page1Feed, expectedPage2Entries.Last().CreatedDate);
            Assert.AreEqual(10, page1Feed.Items.Count());
            for(int i =0; i < 10; i++)
            {
                ValidateFeedItem(page1Feed.Items.ElementAt(i), expectedPage2Entries[i]);
            }
            // check navgation links
            CheckLink(page1Feed, SelfLinkType, _endpointUrl);
            CheckLink(page1Feed, CurrentLinkType, GetPageUrl(2));
            CheckLink(page1Feed, PreviousLinkType, GetPageUrl(1));
            CheckLink(page1Feed, NextLinkType, null);

            // Retrieve page 1
            var page0Feed = await RetrieveFeed(GetPageUrl(1), false, MaxCacheTimespan);
            var expectedPage1Entries = entries.Take(10).ToList();
            ValidateAtomFeedHeader(page0Feed, expectedPage1Entries.Last().CreatedDate);
            Assert.AreEqual(10, page0Feed.Items.Count());
            for (int i = 0; i < 10; i++)
            {
                ValidateFeedItem(page0Feed.Items.ElementAt(i), expectedPage1Entries[i]);
            }
            // check navgation links
            CheckLink(page0Feed, SelfLinkType, _endpointUrl);
            CheckLink(page0Feed, CurrentLinkType, GetPageUrl(1));
            CheckLink(page0Feed, PreviousLinkType, null);
            CheckLink(page0Feed, NextLinkType, GetPageUrl(2));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void AllocationNotificationFeed_ShouldReturnLatestPage10When10InTable()
        {
            // Arrange
            const int numItems = 10;
            RemoveExistingItemsAndAddNewItems(numItems);

            // Act
            SyndicationFeed latestPageFeed = RetrieveFeed(_endpointUrl, true, null).Result;

            // Assert
            Assert.AreEqual(numItems, latestPageFeed.Items.Count());
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public async Task AllocationNotificationFeed_NoAuthCredentialsForFeedHeadShouldReturn401Test()
        {
            using(var client = CreateClient(false))
            {
                var response = await client.GetAsync(_endpointUrl);
                Assert.AreEqual(HttpStatusCode.Unauthorized, response.StatusCode);
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public async Task AllocationNotificationFeed_NoAuthCredentialsForFeedPageShouldReturn401Test()
        {
            using (var client = CreateClient(false))
            {
                var response = await client.GetAsync(GetPageUrl(1));
                Assert.AreEqual(HttpStatusCode.Unauthorized, response.StatusCode);
            }
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public async Task AllocationNotificationFeed_PageDoesNotExistShouldReturn404Test()
        {
            AllocationDeliveryEntrySetup.ClearAllocationDeliveryEntryAndData();

            using(var client = CreateClient())
            {
                var response = await client.GetAsync(GetPageUrl(2));
                Assert.AreEqual(HttpStatusCode.NotFound, response.StatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task AllocationNotificationFeed_ShouldReturnExpectedCacheControlHeaders()
        {
            // arrange 4 pages including latest
            AllocationDeliveryEntrySetup.ClearAllocationDeliveryEntryAndData();

            for (int i = 1; i <= 40; i++)
            {
                AllocationDeliveryEntry entry = CreateAllocationDeliveryEntry(
                    AllocationDeliveryEntryCategory.NewContractAllocationApproved,
                    DateTime.Now.AddSeconds(i));
                AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(entry, new AllocationDeliveryPerformance());
            }

            // act, assert latest page
            using (HttpClient client = CreateClient())
            {
                HttpResponseMessage response = await client.GetAsync(_endpointUrl);

                Assert.IsTrue(response.Headers.CacheControl.NoCache, "Latest page Cache-Control: no-cache was false");
                Assert.IsNull(response.Headers.CacheControl.MaxAge, "Latest page Cache-Control: max-age was not null");
            }

            // act, assert page 3
            using (HttpClient client = CreateClient())
            {
                HttpResponseMessage response = await client.GetAsync(GetPageUrl(3));

                Assert.IsTrue(response.Headers.CacheControl.NoCache, "Highest-numbered page Cache-Control: no-cache was false");
                Assert.IsNull(response.Headers.CacheControl.MaxAge, "Highest-numbered page Cache-Control: max-age was not null");
            }

            // act, assert page 2
            using (HttpClient client = CreateClient())
            {
                HttpResponseMessage response = await client.GetAsync(GetPageUrl(2));

                Assert.IsFalse(response.Headers.CacheControl.NoCache, "Archived page Cache-Control: no-cache was true");
                Assert.AreEqual(MaxCacheTimespan, response.Headers.CacheControl.MaxAge, "Archived page Cache-Control: max-age was not as expected");
                Assert.IsFalse(response.Headers.CacheControl.Private, "Archived page Cache-Control: private was true");
            }

            // act, assert page 1
            using (HttpClient client = CreateClient())
            {
                HttpResponseMessage response = await client.GetAsync(GetPageUrl(1));

                Assert.IsFalse(response.Headers.CacheControl.NoCache, "Archived page Cache-Control: no-cache was true");
                Assert.AreEqual(MaxCacheTimespan, response.Headers.CacheControl.MaxAge, "Archived page Cache-Control: max-age was not as expected");
                Assert.IsFalse(response.Headers.CacheControl.Private, "Archived page Cache-Control: private was true");
            }
        }

        // if expectedValue == null, we check that link is not there
        private void CheckLink(SyndicationFeed feed, string linkType, string expectedUri)
        {
            var link = feed.Links.SingleOrDefault(l => l.RelationshipType == linkType);
            if (expectedUri == null)
            {
                Assert.IsNull(link, "found {0} link that we expected not to exist", linkType);
            }
            else
            {
                Assert.IsNotNull(link, linkType + " link is missing");
                Assert.AreEqual(expectedUri, link.Uri.AbsoluteUri);
            }
        }

        private string GetPageUrl(int pageNumber)
        {
            return _endpointUrl.EndsWith("/") ? _endpointUrl + pageNumber : string.Format("{0}/{1}", _endpointUrl, pageNumber);
        }

        private async Task<SyndicationFeed> RetrieveFeed(string requestUri, bool expectedNoCacheHeader, TimeSpan? expectedMaxCacheAge)
        {
            HttpResponseMessage response;
            using (var client = CreateClient())
            {
                response = await client.GetAsync(requestUri);
            }

            // Assert

            Assert.IsTrue(response.IsSuccessStatusCode, "Atom feed returned status code " + response.StatusCode.ToString());

            Assert.AreEqual(expectedNoCacheHeader, response.Headers.CacheControl.NoCache);
            Assert.AreEqual(expectedMaxCacheAge, response.Headers.CacheControl.MaxAge);
            return SyndicationFeed.Load(new XmlTextReader(new StringReader(await response.Content.ReadAsStringAsync())));
        }

        private static void ValidateAtomFeedHeader(SyndicationFeed feed, DateTime updated)
        {
            Assert.IsNotNull(feed);
            Assert.AreEqual("Allocation Delivery Monitoring Notifications", feed.Title.Text);
            Assert.AreEqual(new DateTimeOffset(updated).ToString("s"), feed.LastUpdatedTime.ToString("s"));
            Assert.AreEqual(1, feed.Authors.Count);
            Assert.AreEqual("Allocation Delivery Service", feed.Authors.First().Name);
            Assert.AreEqual("uuid:12537fce-65bc-4f58-bb2d-183f8c3ad068", feed.Id);
        }

        private static AllocationDeliveryEntry CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory category, DateTime? createdDate = null)
        {
            var allocationDelivery = new AllocationDeliveryPerformance
            {
                contractAllocationNumber = Guid.NewGuid().ToString().Substring(0, 2),
                Contract = new contractReferenceTYPE { contractNumber = Guid.NewGuid().ToString().Substring(0, 10), contractSubVersionNumber = 1, contractVersionNumber = 2 },
            };

            AllocationDeliveryEntry entry = Create(allocationDelivery, category);
            
            return entry;
        }

        private void ValidateFeedItem(SyndicationItem item, AllocationDeliveryEntry expectedAllocation)
        {
            Assert.AreEqual("application/vnd.sfa.allocation-delivery.allocation-delivery-performance.v1+xml", item.Content.Type, "content type is invalid");
            var xmlContent = ((XmlSyndicationContent)item.Content).GetReaderAtContent().ReadInnerXml();
            AllocationDeliveryPerformance allocation;
            var serializer = new XmlSerializer(typeof(AllocationDeliveryPerformance));
            using (var stringReader = new StringReader(xmlContent))
            {
                allocation = serializer.Deserialize(stringReader) as AllocationDeliveryPerformance;
            }
            Assert.IsNotNull(allocation);
            Assert.AreEqual(expectedAllocation.CreatedDate.ToString("dt"), item.PublishDate.DateTime.ToString("dt"));
            Assert.AreEqual("uuid:" + expectedAllocation.Identifier, item.Id);
            string expectedTitle = string.Empty;
            string expectedCategory = string.Empty;
            switch (expectedAllocation.AllocationDeliveryCategory)
            {
                case AllocationDeliveryEntryCategory.NewContractAllocationApproved:
                    expectedTitle = string.Format("New Contract {0}: {1}.{2} with Allocation {3} was Approved", expectedAllocation.ContractNumber, expectedAllocation.VersionNumber, expectedAllocation.SubVersionNumber, expectedAllocation.AllocationNumber);
                    expectedCategory = "New Contract Allocation Approved";
                    break;
                case AllocationDeliveryEntryCategory.AmendedContractAllocationApproved:
                    expectedTitle = string.Format("Amendment to Contract {0}: {1}.{2} with Allocation {3} was Approved", expectedAllocation.ContractNumber, expectedAllocation.VersionNumber, expectedAllocation.SubVersionNumber, expectedAllocation.AllocationNumber);
                    expectedCategory = "Amended Contract Allocation Approved";
                    break;
                case AllocationDeliveryEntryCategory.ContractAllocationActualsReceived:
                    expectedTitle = string.Format("Actuals for Allocation {0} of Contract {1}: {2}.{3} have been received", expectedAllocation.AllocationNumber, expectedAllocation.ContractNumber, expectedAllocation.VersionNumber, expectedAllocation.SubVersionNumber);
                    expectedCategory = "Contract Allocation Actuals Received";
                    break;
                case AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived:
                    expectedTitle = string.Format("Payment for Allocation {0} of Contract {1}: {2}.{3} have been posted", expectedAllocation.AllocationNumber, expectedAllocation.ContractNumber, expectedAllocation.VersionNumber, expectedAllocation.SubVersionNumber);
                    expectedCategory = "Contract Allocation Payment Posted";
                    break;
            }

            Assert.AreEqual(expectedCategory, item.Categories.First().Label);
            Assert.IsNull(item.Summary);
            Assert.AreEqual(expectedTitle, item.Title.Text);
        }

        private HttpClient CreateClient(bool includeAuthHeader = true)
        {
            var client = new HttpClient();
            client.BaseAddress = new Uri(new AppConfiguration()["ContractManagementServiceUrl"]);
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("APPLICATION/ATOM+XML"));
            if (includeAuthHeader)
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
            return client;
        }

        private void RemoveExistingItemsAndAddNewItems(int numNewItems)
        {
            AllocationDeliveryEntrySetup.ClearAllocationDeliveryEntryAndData();

            for (int i = 0; i < numNewItems; i++)
            {
                var entry = CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.NewContractAllocationApproved, DateTime.Now.AddSeconds(i));
                AllocationDeliveryEntrySetup.InsertAllocationDeliveryEntryAndBytes(entry, new AllocationDeliveryPerformance());
            }
        }

        public static AllocationDeliveryEntry Create(AllocationDeliveryPerformance allocationDeliveryPerformance, AllocationDeliveryEntryCategory category)
        {
            AllocationDeliveryEntry allocationDeliveryEntry = new AllocationDeliveryEntry();
         //   allocationDeliveryEntry.SetAllocationDeliveryPerformance(allocationDeliveryPerformance, allocationDeliveryEntry);
            allocationDeliveryEntry.Identifier = Guid.NewGuid();
            allocationDeliveryEntry.AllocationNumber = allocationDeliveryPerformance.contractAllocationNumber;
            allocationDeliveryEntry.VersionNumber = allocationDeliveryPerformance.Contract.contractVersionNumber;
            allocationDeliveryEntry.SubVersionNumber = allocationDeliveryPerformance.Contract.contractSubVersionNumber;
            allocationDeliveryEntry.ContractNumber = allocationDeliveryPerformance.Contract.contractNumber;
            allocationDeliveryEntry.SchemaVersion = allocationDeliveryPerformance.schemaVersion.ToString(CultureInfo.InvariantCulture);
            allocationDeliveryEntry.AllocationDeliveryCategory = category;

            return allocationDeliveryEntry;
        }
    }
}
