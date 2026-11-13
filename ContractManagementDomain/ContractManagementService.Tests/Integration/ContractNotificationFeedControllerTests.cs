namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;
    using System.Xml;
    using AtomFeed;
    using Dapper;
    using FluentAssertions;
    using global::ContractManagementService.Tests;
    using Microsoft.AspNetCore;
    using Microsoft.AspNetCore.Hosting;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.TestHost;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Utils;
    using AtomRelationship = global::ContractManagementService.AtomFeed.AtomRelationship;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Microsoft.Extensions.DependencyInjection;
    using SFA.FCT.ContractManagementService.Controllers;

    [TestClass]
    public class ContractNotificationFeedControllerTests : IntegrationTestBase
    {
        private const string ApprovalsPageSpecificUrl = "/api/contracts/notifications/approvals/{0}";
        private const string ApprovalsMostRecentPageUrl = "/api/contracts/notifications/approvals";
        private IApprovedContractAtomItemRepository _approvedContractAtomItemRepository;

        private const string DraftPageSpecificUrl = "/api/contracts/notifications/draft/{0}";
        private const string DraftMostRecentPageUrl = "/api/contracts/notifications/draft";

        private const string AllPageSpecificUrl = "/api/contracts/notifications/{0}";
        private const string AllMostRecentPageUrl = "/api/contracts/notifications/";

        private const string ApprovalOnwardsPageSpecificUrl = "/api/contracts/notifications/approval-onwards/{0}";
        private const string ApprovalOnwardsMostRecentPageUrl = "/api/contracts/notifications/approval-onwards";

        private readonly List<int> _listofIds = new List<int>();

        [TestInitialize]
        public void TestInitialize()
        {
            _approvedContractAtomItemRepository = GetIocServiceProvider().GetService<IApprovedContractAtomItemRepository>();
            DeleteAllFromAtomFeedItemTable();
        }

        private IServiceProvider GetIocServiceProvider()
        {
            return Container;
        }

        private static string BaseAddress => new AppConfiguration()["ContractManagementServiceUrl"];


        #region Contract Approved Notification

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldRejectWithMediaTypeNotSupported_WhenEndpointCalledWithUnsupportedMediaType()
        {
            Assert.IsTrue(await
                    CallEndpointAndCheckStatusCodeForMediaType("application/json", HttpStatusCode.UnsupportedMediaType,
                        ApprovalsMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldNotReject_IfMediaTypeIsAtomXml()
        {
            Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml",
                HttpStatusCode.OK,
                ApprovalsMostRecentPageUrl));

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldReturn404_IfPageNotFound()
        {
            var testServer = new TestServer(
                WebHost.CreateDefaultBuilder()
                    .UseStartup<Startup>()
            );

            var httpClient = testServer.CreateClient();
            string url = $"http://localhost:13583{string.Format(ApprovalsPageSpecificUrl, 100)}";
            httpClient.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue("application/atom+xml"));
            AddAuthorizationHeader(httpClient);
            // act
            var response = await httpClient.GetAsync(url);
            
            // assert
            response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(21,AtomItemType.ApprovedContract);
                string url = string.Format(ApprovalsPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15,  AtomItemType.ApprovedContract);
                string url = string.Format(ApprovalsPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldReturnCorrectContentTypesForNextPrevLinks()
        {
            try
            {
                const string vendorAtomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
                SetupDatabaseWithANumberOfRows(35,AtomItemType.ApprovedContract);
                string url = string.Format(ApprovalsPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync(vendorAtomMediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsNotNull(feed);
                Assert.AreEqual(
                    vendorAtomMediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.PreviousRelationship).MediaType);
                Assert.AreEqual(
                    vendorAtomMediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.NextRelationship).MediaType);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldReturnASyndicationFeedForTheCurrentPageWithNoNextLink()
        {
            TearDown();
            string url = ApprovalsMostRecentPageUrl;
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Links.Count(li => li.RelationshipType == AtomRelationship.NextRelationship) == 0, "We have returned a next link for the current page");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsWhenCalledWithMostRecentPageUrl()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15,AtomItemType.ApprovedContract);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", ApprovalsMostRecentPageUrl);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 5);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXmlForVersionedActionType()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15, AtomItemType.ApprovedContract);
                string url = string.Format(ApprovalsPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/vnd.sfa.contract.v1+atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldRejectIfMediaTypeIsAtomJson()
        {
            Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+json", HttpStatusCode.UnsupportedMediaType,ApprovalsMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovedNotificationFeedAtomFeed_ShouldRejectWithBadRequest_WhenPageNumberOutRange()
        {
            string url = string.Format(ApprovalsPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml", HttpStatusCode.NotFound, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovedNotificationFeedAtomFeed_ShouldRejectWithUnsupportedMediaType_WhenCallingWithoutAMediaType()
        {
            string url = string.Format(ApprovalsPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode.UnsupportedMediaType, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldGetLatestContractsThenWalkLinksToTheStart()
        {
            const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
            SetupDatabaseWithANumberOfRows(31, AtomItemType.ApprovedContract);
            var response = await CallEndpointAndReturnResultAsync(atomMediaType, ApprovalsMostRecentPageUrl);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Items.Count() == 1);

            // now use the prev links
            int numArchivedPages = 0;
            SyndicationLink link = null;
            do
            {
                link =
                    feed.Links.FirstOrDefault(
                        li => li.RelationshipType == AtomRelationship.PreviousRelationship);

                if (link != null)
                {
                    // now call end point again
                    response = await CallEndpointAndReturnResultAsync(atomMediaType, link.Uri.AbsolutePath);
                    feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                    numArchivedPages++;
                }

            } while (link != null);

            Assert.IsTrue(numArchivedPages == 3);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovedNotificationFeedAtomFeed_ShouldGetFirstContractsThenWalkLinksToTheEnd()
        {
            try
            {
                TearDown();
                const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
                SetupDatabaseWithANumberOfRows(31,AtomItemType.ApprovedContract);
                string url = string.Format(ApprovalsPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync(atomMediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);

                // now use the next links
                int numNextPages = 0;
                SyndicationLink link = null;
                do
                {
                    link =
                        feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.NextRelationship) ??
                        feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.SelfRelationship);

                    if (link != null)
                    {
                        // now call end point again
                        response = await CallEndpointAndReturnResultAsync(atomMediaType, link.Uri.AbsolutePath);
                        feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                        numNextPages++;
                    }

                } while (link != null && link.RelationshipType != AtomRelationship.SelfRelationship);

                Assert.IsTrue(numNextPages == 3);
            }
            finally
            {
                TearDown();
            }
        }

        #endregion


        #region Contract Draft Notification

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldRejectWithMediaTypeNotSupported_WhenEndpointCalledWithUnsupportedMediaType()
        {
            Assert.IsTrue(await
                      CallEndpointAndCheckStatusCodeForMediaType("application/json",
                      HttpStatusCode.UnsupportedMediaType,
                          DraftMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldNotReject_IfMediaTypeIsAtomXml()
        {
            Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml",
                HttpStatusCode.OK,
                DraftMostRecentPageUrl));

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(21,AtomItemType.DraftContract);
                string url = string.Format(DraftPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15,AtomItemType.DraftContract);
                string url = string.Format(DraftPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldReturnCorrectContentTypesForNextPrevLinks()
        {
            try
            {
                const string vendorAtomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
                SetupDatabaseWithANumberOfRows(35, AtomItemType.DraftContract);
                string url = string.Format(DraftPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync(vendorAtomMediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsNotNull(feed);
                Assert.AreEqual(
                    vendorAtomMediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.PreviousRelationship).MediaType);
                Assert.AreEqual(
                    vendorAtomMediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.NextRelationship).MediaType);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldReturnASyndicationFeedForTheCurrentPageWithNoNextLink()
        {
            TearDown();
            string url = DraftMostRecentPageUrl;
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Links.Count(li => li.RelationshipType == AtomRelationship.NextRelationship) == 0, "We have returned a next link for the current page");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsWhenCalledWithMostRecentPageUrl()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15, AtomItemType.DraftContract);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", DraftMostRecentPageUrl);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 5);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXmlForVersionedActionType()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15, AtomItemType.DraftContract);
                string url = string.Format(DraftPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/vnd.sfa.contract.v1+atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldRejectIfMediaTypeIsAtomJson()
        {
            Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+json", HttpStatusCode.UnsupportedMediaType, DraftMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDraftNotificationFeedAtomFeed_ShouldRejectWithBadRequest_WhenPageNumberOutRange()
        {
            string url = string.Format(DraftPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml", HttpStatusCode.NotFound, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDraftNotificationFeedAtomFeed_ShouldRejectWithUnsupportedMediaType_WhenCallingWithoutAMediaType()
        {
            string url = string.Format(DraftPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode.UnsupportedMediaType, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldGetLatestContractsThenWalkLinksToTheStart()
        {
            const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
            SetupDatabaseWithANumberOfRows(31, AtomItemType.DraftContract);
            var response = await CallEndpointAndReturnResultAsync(atomMediaType, DraftMostRecentPageUrl);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Items.Count() == 1);

            // now use the prev links
            int numArchivedPages = 0;
            SyndicationLink link = null;
            do
            {
                link =
                    feed.Links.FirstOrDefault(
                        li => li.RelationshipType == AtomRelationship.PreviousRelationship);

                if (link != null)
                {
                    // now call end point again
                    response = await CallEndpointAndReturnResultAsync(atomMediaType, link.Uri.AbsolutePath);
                    feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                    numArchivedPages++;
                }

            } while (link != null);

            Assert.IsTrue(numArchivedPages == 3);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractDraftNotificationFeedAtomFeed_ShouldGetFirstContractsThenWalkLinksToTheEnd()
        {
            try
            {
                TearDown();
                const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
                SetupDatabaseWithANumberOfRows(31, AtomItemType.DraftContract);
                string url = string.Format(DraftPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync(atomMediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);

                // now use the next links
                int numNextPages = 0;
                SyndicationLink link = null;
                do
                {
                    link =
                        feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.NextRelationship) ??
                        feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.SelfRelationship);

                    if (link != null)
                    {
                        // now call end point again
                        response = await CallEndpointAndReturnResultAsync(atomMediaType, link.Uri.AbsolutePath);
                        feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                        numNextPages++;
                    }

                } while (link != null && link.RelationshipType != AtomRelationship.SelfRelationship);

                Assert.IsTrue(numNextPages == 3);
            }
            finally
            {
                TearDown();
            }
        }

        #endregion


        #region Contract All Notification

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractAllNotificationFeedAtomFeedController_ShouldGetLatestPage()
        {
            using (var context = new ContractManagementDbContext())
            {
                IAtomItemRepository atomItemRepository = new ApprovedContractAtomItemRepository(context);
                context.Database.ExecuteSqlCommand("delete from [ContractManagement].[AtomFeedItem]");
            }

            SetupDatabaseWithANumberOfRows(1, AtomItemType.ApprovedContract);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.DraftContract);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.WithdrawnContract);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.ClosedContract);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.ContractTerminationInitiated);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.CancelledContractTermination);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.ContractTerminated);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.ContractTerminationDetailsUpdated);

            using (var context = new ContractManagementDbContext())
            {
                ContractNotificationFeedController controller =
                    new ContractNotificationFeedController(
                        new ApprovedContractAtomItemRepository(context),
                        new AtomFeed.AtomFeedGenerator<AtomFeedItem>(),
                        new AllocationFeedPageNumberMutator(),
                        new DraftContractAtomItemRepository(context),
                        new AllContractAtomItemRepository(new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"])),
                        new ApprovalOnwardsContractAtomItemRepository(context), new AppConfiguration());

                ActionResult response = controller.GetLatestAllContractsPage();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldRejectWithMediaTypeNotSupported_WhenEndpointCalledWithUnsupportedMediaType()
        {
            Assert.IsTrue(await
                      CallEndpointAndCheckStatusCodeForMediaType("application/json",
                      HttpStatusCode.UnsupportedMediaType,
                          AllMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAlltNotificationFeedAtomFeed_ShouldNotReject_IfMediaTypeIsAtomXml()
        {
           Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml",
                HttpStatusCode.OK,
                AllMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(7, AtomItemType.DraftContract);
                SetupDatabaseWithANumberOfRows(7, AtomItemType.ApprovedContract);
                SetupDatabaseWithANumberOfRows(7, AtomItemType.WithdrawnContract);
                string url = string.Format(AllPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(5, AtomItemType.DraftContract);
                SetupDatabaseWithANumberOfRows(5, AtomItemType.ApprovedContract);
                SetupDatabaseWithANumberOfRows(5, AtomItemType.WithdrawnContract);
                string url = string.Format(AllPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldReturnCorrectContentTypesForNextPrevLinks()
        {
            try
            {
                const string vendorAtomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
                SetupDatabaseWithANumberOfRows(20, AtomItemType.DraftContract);
                SetupDatabaseWithANumberOfRows(10, AtomItemType.ApprovedContract);
                SetupDatabaseWithANumberOfRows(5, AtomItemType.WithdrawnContract);
                string url = string.Format(AllPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync(vendorAtomMediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsNotNull(feed);
                Assert.AreEqual(
                    vendorAtomMediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.PreviousRelationship).MediaType);
                Assert.AreEqual(
                    vendorAtomMediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.NextRelationship).MediaType);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldReturnASyndicationFeedForTheCurrentPageWithNoNextLink()
        {
            TearDown();
            string url = AllMostRecentPageUrl;
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Links.Count(li => li.RelationshipType == AtomRelationship.NextRelationship) == 0, "We have returned a next link for the current page");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsWhenCalledWithMostRecentPageUrl()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(5, AtomItemType.DraftContract);
                SetupDatabaseWithANumberOfRows(5, AtomItemType.ApprovedContract);
                SetupDatabaseWithANumberOfRows(5, AtomItemType.WithdrawnContract);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", AllMostRecentPageUrl);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 5);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXmlForVersionedActionType()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(5, AtomItemType.DraftContract);
                SetupDatabaseWithANumberOfRows(5, AtomItemType.ApprovedContract);
                SetupDatabaseWithANumberOfRows(5, AtomItemType.WithdrawnContract);
                string url = string.Format(AllPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/vnd.sfa.contract.v1+atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldRejectIfMediaTypeIsAtomJson()
        {
            Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+json", HttpStatusCode.UnsupportedMediaType, AllMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllNotificationFeedAtomFeed_ShouldRejectWithBadRequest_WhenPageNumberOutRange()
        {
            string url = string.Format(AllPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml", HttpStatusCode.NotFound, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllNotificationFeedAtomFeed_ShouldRejectWithUnsupportedMediaType_WhenCallingWithoutAMediaType()
        {
            string url = string.Format(AllPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode.UnsupportedMediaType, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldGetLatestContractsThenWalkLinksToTheStart()
        {
            const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
            SetupDatabaseWithANumberOfRows(10, AtomItemType.DraftContract);
            SetupDatabaseWithANumberOfRows(10, AtomItemType.ApprovedContract);
            SetupDatabaseWithANumberOfRows(11, AtomItemType.WithdrawnContract);
            var response = await CallEndpointAndReturnResultAsync(atomMediaType, AllMostRecentPageUrl);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Items.Count() == 1);

            // now use the prev links
            int numArchivedPages = 0;
            SyndicationLink link = null;
            do
            {
                link =
                    feed.Links.FirstOrDefault(
                        li => li.RelationshipType == AtomRelationship.PreviousRelationship);

                if (link != null)
                {
                    // now call end point again
                    response = await CallEndpointAndReturnResultAsync(atomMediaType, link.Uri.AbsolutePath);
                    feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                    numArchivedPages++;
                }

            } while (link != null);

            Assert.IsTrue(numArchivedPages == 3);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractAllNotificationFeedAtomFeed_ShouldGetFirstContractsThenWalkLinksToTheEnd()
        {
            try
            {
                TearDown();
                const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
                SetupDatabaseWithANumberOfRows(11, AtomItemType.DraftContract);
                SetupDatabaseWithANumberOfRows(10, AtomItemType.ApprovedContract);
                SetupDatabaseWithANumberOfRows(10, AtomItemType.WithdrawnContract);
                string url = string.Format(AllPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync(atomMediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);

                // now use the next links
                int numNextPages = 0;
                SyndicationLink link = null;
                do
                {
                    link =
                        feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.NextRelationship) ??
                        feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.SelfRelationship);

                    if (link != null)
                    {
                        // now call end point again
                        response = await CallEndpointAndReturnResultAsync(atomMediaType, link.Uri.AbsolutePath);
                        feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                        numNextPages++;
                    }

                } while (link != null && link.RelationshipType != AtomRelationship.SelfRelationship);

                Assert.IsTrue(numNextPages == 3);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithAllExpectedEventTypesAndSummaryAsJson()
        {
            try
            {
                // arrange
                SetupDatabaseWithANumberOfRows(1, AtomItemType.ApprovedContract);
                SetupDatabaseWithANumberOfRows(1, AtomItemType.ClosedContract);
                SetupDatabaseWithANumberOfRows(1, AtomItemType.DraftContract);
                SetupDatabaseWithANumberOfRows(1, AtomItemType.WithdrawnContract);

                // act
                string response = CallEndpointAndReturnResultAsync("application/atom+xml", AllMostRecentPageUrl).Result;

                // assert
                SyndicationFeed feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsNotNull(feed, "Returned feed was null");
                Assert.IsNotNull(feed.Items.SingleOrDefault(i => i.Title.Text.Contains("Approved")), "No approved contract returned");
                Assert.IsNotNull(feed.Items.SingleOrDefault(i => i.Title.Text.Contains("Closed")), "No closed contract returned");
                Assert.IsNotNull(feed.Items.SingleOrDefault(i => i.Title.Text.Contains("Published to Provider")), "No draft contract returned");
                Assert.IsNotNull(feed.Items.SingleOrDefault(i => i.Title.Text.Contains("Withdrawn")), "No withdrawn contract returned");

                // now check that the summary is json
                Assert.IsTrue(feed.Items.All(i => IsJson(i.Summary.Text)), $"The Summary section is not valid json e.g {feed.Items.FirstOrDefault(i => !IsJson(i.Summary.Text))?.Summary?.Text}");
            }
            finally
            {
                TearDown();
            }
        }

        private bool IsJson(string jsonText)
        {
            try
            {
                object jsonBoject = JsonConvert.DeserializeObject(jsonText);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        #endregion

        #region Contract Approval Onwards Notification

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractApprovalOnwardsNotificationFeedAtomFeedController_ShouldGetLatestPage()
        {
            using (var context = new ContractManagementDbContext())
            {
                IAtomItemRepository atomItemRepository = new ApprovedContractAtomItemRepository(context);
                context.Database.ExecuteSqlCommand("delete from [ContractManagement].[AtomFeedItem]");
            }

            SetupDatabaseWithANumberOfRows(1, AtomItemType.ApprovedContract);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.DraftContract);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.WithdrawnContract);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.ClosedContract);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.ContractTerminationInitiated);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.CancelledContractTermination);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.ContractTerminated);
            SetupDatabaseWithANumberOfRows(1, AtomItemType.ContractTerminationDetailsUpdated);

            using (var context = new ContractManagementDbContext())
            {
                ContractNotificationFeedController controller =
                    new ContractNotificationFeedController(
                        new ApprovedContractAtomItemRepository(context),
                        new AtomFeed.AtomFeedGenerator<AtomFeedItem>(),
                        new AllocationFeedPageNumberMutator(),
                        new DraftContractAtomItemRepository(context),
                        new AllContractAtomItemRepository(new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"])),
                        new ApprovalOnwardsContractAtomItemRepository(context), new AppConfiguration());

                ActionResult response = controller.GetLatestApprovedOnwardsContractsPage();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldRejectWithMediaTypeNotSupported_WhenEndpointCalledWithUnsupportedMediaType()
        {
            Assert.IsTrue(await
                      CallEndpointAndCheckStatusCodeForMediaType("application/json",
                      HttpStatusCode.UnsupportedMediaType,
                          ApprovalOnwardsMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldNotReject_IfMediaTypeIsAtomXml()
        {
            Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml",
                HttpStatusCode.OK,
                ApprovalOnwardsMostRecentPageUrl));

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(21, AtomItemType.ClosedContract);
                string url = string.Format(ApprovalOnwardsPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithApprovedAndClosedEvents()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(1, AtomItemType.ClosedContract);
                SetupDatabaseWithANumberOfRows(1, AtomItemType.ApprovedContract);
                SetupDatabaseWithANumberOfRows(5, AtomItemType.DraftContract);
                SetupDatabaseWithANumberOfRows(3, AtomItemType.WithdrawnContract);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", ApprovalOnwardsMostRecentPageUrl);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.AreEqual(2, feed.Items.Count());
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15, AtomItemType.ClosedContract);
                string url = string.Format(ApprovalOnwardsPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldReturnCorrectContentTypesForNextPrevLinks()
        {
            try
            {
                const string vendorAtomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
                SetupDatabaseWithANumberOfRows(35, AtomItemType.ClosedContract);
                string url = string.Format(ApprovalOnwardsPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync(vendorAtomMediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsNotNull(feed);
                Assert.AreEqual(
                    vendorAtomMediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.PreviousRelationship).MediaType);
                Assert.AreEqual(
                    vendorAtomMediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.NextRelationship).MediaType);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldReturnASyndicationFeedForTheCurrentPageWithNoNextLink()
        {
            TearDown();
            string url = ApprovalOnwardsMostRecentPageUrl;
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Links.Count(li => li.RelationshipType == AtomRelationship.NextRelationship) == 0, "We have returned a next link for the current page");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsWhenCalledWithMostRecentPageUrl()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15, AtomItemType.ClosedContract);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", ApprovalOnwardsMostRecentPageUrl);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 5);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXmlForVersionedActionType()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15, AtomItemType.ClosedContract);
                string url = string.Format(ApprovalOnwardsPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/vnd.sfa.contract.v1+atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldRejectIfMediaTypeIsAtomJson()
        {
            Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+json", HttpStatusCode.UnsupportedMediaType, ApprovalOnwardsMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldRejectWithBadRequest_WhenPageNumberOutRange()
        {
            string url = string.Format(ApprovalOnwardsPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml", HttpStatusCode.NotFound, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldRejectWithUnsupportedMediaType_WhenCallingWithoutAMediaType()
        {
            string url = string.Format(ApprovalOnwardsPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode.UnsupportedMediaType, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldGetLatestContractsThenWalkLinksToTheStart()
        {
            const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
            SetupDatabaseWithANumberOfRows(31, AtomItemType.ClosedContract);
            var response = await CallEndpointAndReturnResultAsync(atomMediaType, ApprovalOnwardsMostRecentPageUrl);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Items.Count() == 1);

            // now use the prev links
            int numArchivedPages = 0;
            SyndicationLink link = null;
            do
            {
                link =
                    feed.Links.FirstOrDefault(
                        li => li.RelationshipType == AtomRelationship.PreviousRelationship);

                if (link != null)
                {
                    // now call end point again
                    response = await CallEndpointAndReturnResultAsync(atomMediaType, link.Uri.AbsolutePath);
                    feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                    numArchivedPages++;
                }

            } while (link != null);

            Assert.IsTrue(numArchivedPages == 3);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldGetFirstContractsThenWalkLinksToTheEnd()
        {
            try
            {
                TearDown();
                const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
                SetupDatabaseWithANumberOfRows(31, AtomItemType.ClosedContract);
                string url = string.Format(ApprovalOnwardsPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync(atomMediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);

                // now use the next links
                int numNextPages = 0;
                SyndicationLink link = null;
                do
                {
                    link =
                        feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.NextRelationship) ??
                        feed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.SelfRelationship);

                    if (link != null)
                    {
                        // now call end point again
                        response = await CallEndpointAndReturnResultAsync(atomMediaType, link.Uri.AbsolutePath);
                        feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                        numNextPages++;
                    }

                } while (link != null && link.RelationshipType != AtomRelationship.SelfRelationship);

                Assert.IsTrue(numNextPages == 3);
            }
            finally
            {
                TearDown();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldShowContractItemsUnderTermination()
        {
            // arrange
            const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
            SetupDatabaseWithANumberOfRows(5, AtomItemType.ContractTerminationInitiated);
            string url = ApprovalOnwardsMostRecentPageUrl;

            // act
            var response = await CallEndpointAndReturnResultAsync(atomMediaType, url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));

            // assert
            Assert.IsTrue(feed != null, "Feed was null");
            Assert.IsTrue(feed.Items.Count(ai => ai.Title.Text.Contains("was placed under termination")) == 5, "Did not retrieve correct number of terminated items");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ContractApprovalOnwardsNotificationFeedAtomFeed_ShouldShowCancelledContractTerminationItems()
        {
            // arrange
            const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
            SetupDatabaseWithANumberOfRows(5, AtomItemType.CancelledContractTermination);
            string url = ApprovalOnwardsMostRecentPageUrl;

            // act
            var response = await CallEndpointAndReturnResultAsync(atomMediaType, url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));

            // assert
            Assert.IsTrue(feed != null, "Feed was null");
            Assert.IsTrue(feed.Items.Count(ai => ai.Title.Text.Contains("was cancelled")) == 5, "Did not retrieve correct number of cancelled termination items");
        }

        #endregion

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task AllContractNotificationFeedAtomFeed_ShouldShowContractItemsUnderTermination()
        {
            // arrange
            const string atomMediaType = "application/vnd.sfa.contract.v1+atom+xml";
            SetupDatabaseWithANumberOfRows(5, AtomItemType.ContractTerminationInitiated);
            string url = string.Format(AllMostRecentPageUrl);

            // act
            var response = await CallEndpointAndReturnResultAsync(atomMediaType, url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));

            // assert
            Assert.IsTrue(feed != null, "Feed was null");
            Assert.IsTrue(feed.Items.Count(ai => ai.Title.Text.Contains("was placed under termination")) == 5, "Did not retrieve correct number of terminated items");
        }

        private async Task<bool> CallEndpointAndCheckStatusCodeForMediaType(string mediaType, HttpStatusCode statusCode, string url)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));
            AddAuthorizationHeader(client);
            var result = await client.GetAsync(BaseAddress + url);
            return result.StatusCode == statusCode;
        }

        private async Task<bool> CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode statusCode, string url)
        {
            var client = new HttpClient();
            AddAuthorizationHeader(client);
            var result = await client.GetAsync(BaseAddress + url);
            return result.StatusCode == statusCode;
        }

        private async Task<string> CallEndpointAndReturnResultAsync(string mediaType, string url)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));

            AddAuthorizationHeader(client);
            HttpResponseMessage response = await client.GetAsync(BaseAddress + url);
            if (response.IsSuccessStatusCode)
            {
                return
                    await
                        response.Content.ReadAsStringAsync();
            }

            return string.Empty;
        }

        private void AddAuthorizationHeader(HttpClient client)
        {
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
        }
        

        private void SetupDatabaseWithANumberOfRows(int numRows, AtomItemType atomType)
        {
            for (int i = 0; i < numRows; i++)
            {
                var contract = new CorporateSchema.Contract
                {
                    contracts = new List<CorporateSchema.contractType>
                    {
                        new CorporateSchema.contractType
                        {
                            contractNumber = "XXX" + i,
                            contractVersionNumber = 1,
                            hierarchyType = CorporateSchema.hierarchyType.CONTRACT
                        }
                    }
                };
                var entityToStore = AtomFeedItem.CreateAtomFeedItem(contract, contract.GetFirstContractNumber(), atomType, xml => true);
                _approvedContractAtomItemRepository.Add(entityToStore);
                _listofIds.Add(entityToStore.Id);
            }
        }

        private void DeleteAllFromAtomFeedItemTable()
        {
            Connection.Execute("Truncate Table ContractManagement.AtomFeedItem");
        }

        private void TearDown()
        {
            Connection.Execute("delete from ContractManagement.AtomFeedItem where Id in @ids", new {ids = _listofIds});
        }

        private static readonly SqlConnection Connection = new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]);
    }
}