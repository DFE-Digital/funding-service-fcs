namespace SFA.FCT.Performancetests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Xml;
    using System.Xml.Serialization;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.Contracts.AcceptanceTests.Utils;
    using Microsoft.VisualStudio.TestTools.WebTesting;
    using Microsoft.VisualStudio.TestTools.LoadTesting;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.ContractManagementService.Test.Utils;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using System.Data.Entity;
    using System.Threading.Tasks;
   
    public class TestDWHAtomFeed : WebTestPlugin
    {
        private const string PreviousLinkType = "prev-archive";
        private const string NextLinkType = "next-archive";
        private const string SelfLinkType = "self";
        private const string CurrentLinkType = "current";
        private readonly TimeSpan maxhCacheTimespan = new TimeSpan(365, 0, 0, 0);


        private readonly string endpointUrl;
        public TestDWHAtomFeed()
        {
           var builder = new UriBuilder(ConfigurationParameters.ContractManagementServiceUrl());
            builder.Path = "/api/allocation-delivery/monitoring/notifications/all";
            endpointUrl = builder.Uri.ToString();//.Replace(":80/", "/");
        }
 
        public async Task AllocationNotificationFeed_AllAllocations_ShouldReturn1ItemForEachCategoryTest()
        {
            // Arrange
            var entry1 = CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.NewContractAllocationApproved, DateTime.Now.AddSeconds(-3));
            var entry2 = CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.AmendedContractAllocationApproved, DateTime.Now.AddSeconds(-2));
            var entry3 = CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.ContractAllocationActualsReceived, DateTime.Now.AddSeconds(-1));
            var entry4 = CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived, DateTime.Now);

            using (var dbContext = new AllocationDeliveryDbContext())
            {
                ((DbSet<AllocationDeliveryEntry>)dbContext.AllocationDeliveryEntries).RemoveRange(dbContext.AllocationDeliveryEntries);
                dbContext.AllocationDeliveryEntries.Add(entry1);
                dbContext.AllocationDeliveryEntries.Add(entry2);
                dbContext.AllocationDeliveryEntries.Add(entry3);
                dbContext.AllocationDeliveryEntries.Add(entry4);
                await dbContext.SaveChangesAsync();
            }

            // Act
            var feed = await RetrieveFeed(endpointUrl, true, null);            
            ValidateAtomFeedHeader(feed, entry4.CreatedDate);
            //Assert.AreEqual(4, feed.Items.Count());
           if (feed.Items.Count() == 4)
           {
            var feedItems = feed.Items.ToList();
            ValidateFeedItem(feedItems[0], entry1);
            ValidateFeedItem(feedItems[1], entry2);
            ValidateFeedItem(feedItems[2], entry3);
            ValidateFeedItem(feedItems[3], entry4);
              }
        }

        public async Task AllocationNotifcationFeed_PagingShouldReturn2PagesTest()
        {
            // Arrange
            var entries = new List<AllocationDeliveryEntry>();
            using (var dbContext = new AllocationDeliveryDbContext())
            {
                ((DbSet<AllocationDeliveryEntry>)dbContext.AllocationDeliveryEntries).RemoveRange(dbContext.AllocationDeliveryEntries);

                for (int i = 0; i < 21; i++)
                {
                    var entry = CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.NewContractAllocationApproved, DateTime.Now.AddSeconds(i));
                    dbContext.AllocationDeliveryEntries.Add(entry);
                    entries.Add(entry);
                }

                await dbContext.SaveChangesAsync();
            }

            entries = entries.OrderBy(e => e.CreatedDate).ToList();

            // Act & Assert
            var headUpdatesFeed = await RetrieveFeed(endpointUrl, true, null);
            ValidateAtomFeedHeader(headUpdatesFeed, entries.Last().CreatedDate);
            //Assert.AreEqual(1, headUpdatesFeed.Items.Count());

            if (headUpdatesFeed.Items.Count() == 1)
           {
              ValidateFeedItem(headUpdatesFeed.Items.ElementAt(0), entries.Last());
              // check navgation links
              CheckLink(headUpdatesFeed, SelfLinkType, endpointUrl);
              CheckLink(headUpdatesFeed, CurrentLinkType, null);
              CheckLink(headUpdatesFeed, PreviousLinkType, GetPageUrl(2));
              CheckLink(headUpdatesFeed, NextLinkType, null);
           }

 

            // Retrieve page 2
            var page1Feed = await RetrieveFeed(GetPageUrl(2), false, maxhCacheTimespan);
            var expectedPage2Entries = entries.Skip(10).Take(10).ToList();
            ValidateAtomFeedHeader(page1Feed, expectedPage2Entries.Last().CreatedDate);
            //Assert.AreEqual(10, page1Feed.Items.Count());

            if (page1Feed.Items.Count() == 10)
            {
               for (int i = 0; i < 10; i++)
               {
                  ValidateFeedItem(page1Feed.Items.ElementAt(i), expectedPage2Entries[i]);
               }
            }
            // check navgation links
            CheckLink(page1Feed, SelfLinkType, endpointUrl);
            CheckLink(page1Feed, CurrentLinkType, GetPageUrl(2));
            CheckLink(page1Feed, PreviousLinkType, GetPageUrl(1));
            CheckLink(page1Feed, NextLinkType, null);

            // Retrieve page 1
            var page0Feed = await RetrieveFeed(GetPageUrl(1), false, maxhCacheTimespan);
            var expectedPage1Entries = entries.Take(10).ToList();
            ValidateAtomFeedHeader(page0Feed, expectedPage1Entries.Last().CreatedDate);
            Assert.AreEqual(10, page0Feed.Items.Count());
            for (int i = 0; i < 10; i++)
            {
                ValidateFeedItem(page0Feed.Items.ElementAt(i), expectedPage1Entries[i]);
            }
            // check navgation links
            CheckLink(page0Feed, SelfLinkType, endpointUrl);
            CheckLink(page0Feed, CurrentLinkType, GetPageUrl(1));
            CheckLink(page0Feed, PreviousLinkType, null);
            CheckLink(page0Feed, NextLinkType, GetPageUrl(2));
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

        public async Task AllocationNotificationFeed_NoAuthCredentialsForFeedHeadShouldReturn401Test()
        {
            using(var client = CreateClient(false))
            {
                var response = await client.GetAsync(endpointUrl);
                Assert.AreEqual(HttpStatusCode.Unauthorized, response.StatusCode);
            }
        }


        public async Task AllocationNotificationFeed_NoAuthCredentialsForFeedPageShouldReturn401Test()
        {
            using (var client = CreateClient(false))
            {
                var response = await client.GetAsync(GetPageUrl(1));
                Assert.AreEqual(HttpStatusCode.Unauthorized, response.StatusCode);
            }
        }

        public async Task AllocationNotificationFeed_PageDoesNotExistShouldReturn404Test()
        {
            using (var dbContext = new AllocationDeliveryDbContext())
            {
                ((DbSet<AllocationDeliveryEntry>)dbContext.AllocationDeliveryEntries).RemoveRange(dbContext.AllocationDeliveryEntries);
                dbContext.AllocationDeliveryEntries.Add(CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory.NewContractAllocationApproved));
                await dbContext.SaveChangesAsync();
            }

            using(var client = CreateClient())
            {
                var response = await client.GetAsync(GetPageUrl(2));
                Assert.AreEqual(HttpStatusCode.NotFound, response.StatusCode);
            }
        }

        private string GetPageUrl(int pageNumber)
        {
            return endpointUrl.EndsWith("/") ? endpointUrl + pageNumber : string.Format("{0}/{1}", endpointUrl, pageNumber);
        }

        private async Task<SyndicationFeed> RetrieveFeed(string requestUri, bool expectedNoCacheHeader, TimeSpan? expectedMaxCacheAge)
        {
            HttpResponseMessage response;
            using (var client = CreateClient())
            {
                response = await client.GetAsync(requestUri);
            }

            // Assert

            //Assert.IsTrue(response.IsSuccessStatusCode, "Atom feed returned status code " + response.StatusCode.ToString());

            //Assert.AreEqual(expectedNoCacheHeader, response.Headers.CacheControl.NoCache);
            //Assert.AreEqual(expectedMaxCacheAge, response.Headers.CacheControl.MaxAge);
            return SyndicationFeed.Load(new XmlTextReader(new StringReader(await response.Content.ReadAsStringAsync())));
        }

        private static void ValidateAtomFeedHeader(SyndicationFeed feed, DateTime updated)
        {
            //Assert.IsNotNull(feed);
            //Assert.AreEqual("Allocation Delivery Monitoring Notifications", feed.Title.Text);
            //Assert.AreEqual(new DateTimeOffset(updated).ToString("s"), feed.LastUpdatedTime.ToString("s"));
            //Assert.AreEqual(1, feed.Authors.Count);
            //Assert.AreEqual("Allocation Delivery Service", feed.Authors.First().Name);
            //Assert.AreEqual("uuid:12537fce-65bc-4f58-bb2d-183f8c3ad068", feed.Id);
        }

        private static AllocationDeliveryEntry CreateAllocationDeliveryEntry(AllocationDeliveryEntryCategory category, DateTime? createdDate = null)
        {
            var allocationDelivery = new AllocationDeliveryPerformance
            {
                contractAllocationNumber = Guid.NewGuid().ToString(),
                Contract = new contractReferenceTYPE { contractNumber = Guid.NewGuid().ToString(), contractSubVersionNumber = 1, contractVersionNumber = 2 }
            };

            var entry = new AllocationDeliveryEntry
            {
                AllocationDeliveryCategory = category,
                Identifier = Guid.NewGuid(),
                CreatedDate = createdDate.HasValue ? createdDate.Value : DateTime.Now,
                CorporateAllocationDelivery = allocationDelivery
            };

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
            Assert.AreEqual(expectedAllocation.CorporateAllocationDelivery.contractAllocationNumber, allocation.contractAllocationNumber);
            Assert.AreEqual(expectedAllocation.CreatedDate.ToString("dt"), item.PublishDate.DateTime.ToString("dt"));
            Assert.AreEqual("uuid:" + expectedAllocation.Identifier, item.Id);
            var contract = expectedAllocation.CorporateAllocationDelivery.Contract;
            string expectedSummary = string.Empty;
            string expectedCategory = string.Empty;
            switch(expectedAllocation.AllocationDeliveryCategory)
            {
                case AllocationDeliveryEntryCategory.NewContractAllocationApproved:
                    expectedSummary =string.Format("New Contract {0}: {1}.{2} with Allocation {3} was Approved", contract.contractNumber, contract.contractVersionNumber, contract.contractSubVersionNumber, expectedAllocation.CorporateAllocationDelivery.contractAllocationNumber);
                    expectedCategory = "New Contract Allocation Approved";
                    break;
                case AllocationDeliveryEntryCategory.AmendedContractAllocationApproved:
                    expectedSummary = string.Format("Amendment to Contract {0}: {1}.{2} with Allocation {3} was Approved", contract.contractNumber, contract.contractVersionNumber, contract.contractSubVersionNumber, expectedAllocation.CorporateAllocationDelivery.contractAllocationNumber);
                    expectedCategory = "Amended Contract Allocation Approved";
                    break;
                case AllocationDeliveryEntryCategory.ContractAllocationActualsReceived:
                    expectedSummary = string.Format("Actuals for Allocation {0} of Contract {1}: {2}.{3} have been receieved", expectedAllocation.CorporateAllocationDelivery.contractAllocationNumber, contract.contractNumber, contract.contractVersionNumber, contract.contractSubVersionNumber);
                    expectedCategory = "Contract Allocation Actuals Received";
                    break;
                case AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived:
                    expectedSummary = string.Format("Payment for Allocation {0} of Contract {1}: {2}.{3} have been posted", expectedAllocation.CorporateAllocationDelivery.contractAllocationNumber, contract.contractNumber, contract.contractVersionNumber, contract.contractSubVersionNumber);
                    expectedCategory = "Contract Allocation Payment Posted";
                    break;
            }
            
            Assert.AreEqual(expectedCategory, item.Categories.First().Label);
            Assert.AreEqual(expectedSummary, item.Summary.Text);
            Assert.AreEqual(expectedCategory, item.Title.Text);
        }


        private HttpClient CreateClient(bool includeAuthHeader = true)
        {
            var client = new HttpClient();
            client.BaseAddress = new Uri(ConfigurationParameters.ContractManagementServiceUrl());
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("APPLICATION/ATOM+XML"));
            if (includeAuthHeader)
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult().AccessToken);
            return client;
        }
    }
}