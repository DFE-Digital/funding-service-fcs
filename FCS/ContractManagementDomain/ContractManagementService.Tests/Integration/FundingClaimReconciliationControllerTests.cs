namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;
    using System.Xml;
    using CrossDomain.Integration.Common.Atom;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Utils;
    using PerformanceManagementDomain.DataStore.Models;
    using PerformanceManagementDomain.DataStore;
    using System;
    using System.Data.SqlClient;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0;
    using System.Xml.Serialization;
    using CrossDomain.Integration.Entities.Data;
    using global::ContractManagementService.Tests;

    [TestClass]
    public class FundingClaimReconciliationControllerTests : IntegrationTestBase
    {
        private const string FundingClaimReconciliationPageSpecificUrl = "/api/performance-management/funding-claim-reconciliations/notifications/{0}";
        private const string FundingClaimReconciliationMostRecentPageUrl = "/api/performance-management/funding-claim-reconciliations/notifications";
        private readonly string _baseAddress = new AppConfiguration()["ContractManagementServiceUrl"];
        private readonly string _mediaType = "application/vnd.sfa.fundingclaimreconciliation.v1+atom+xml";
        private List<int> _listofUkprns = new List<int>();

        [TestInitialize]
        public void TestInitialize()
        {
            TearDownAll();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            TearDownSpecificUkprns();
        }

        #region FundingClaimReconciliation

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldReturnASyndicationFeedWithForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(21);
                string url = string.Format(FundingClaimReconciliationPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDownSpecificUkprns();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXml()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15);
                string url = string.Format(FundingClaimReconciliationPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDownSpecificUkprns();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldReturnCorrectContentTypesForNextPrevLinks()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(35);
                string url = string.Format(FundingClaimReconciliationPageSpecificUrl, 2);
                var response = await CallEndpointAndReturnResultAsync(_mediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsNotNull(feed);
                Assert.AreEqual(
                    _mediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.PreviousRelationship).MediaType);
                Assert.AreEqual(
                    _mediaType,
                    feed.Links.First(li => li.RelationshipType == AtomRelationship.NextRelationship).MediaType);
            }
            finally
            {
                TearDownSpecificUkprns();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldReturnASyndicationFeedForTheCurrentPageWithNoNextLink()
        {
            TearDownSpecificUkprns();
            string url = FundingClaimReconciliationMostRecentPageUrl;
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsTrue(feed != null);
            Assert.IsTrue(feed.Links.Count(li => li.RelationshipType == AtomRelationship.NextRelationship) == 0, "We have returned a next link for the current page");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldReturnASyndicationFeedWithTenItemsWhenCalledWithMostRecentPageUrl()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15);
                var response = await CallEndpointAndReturnResultAsync("application/atom+xml", FundingClaimReconciliationMostRecentPageUrl);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 5);
            }
            finally
            {
                TearDownSpecificUkprns();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldReturnASyndicationFeedWithTenItemsForAtomXmlForVersionedActionType()
        {
            try
            {
                SetupDatabaseWithANumberOfRows(15);
                string url = string.Format(FundingClaimReconciliationPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync(_mediaType, url);
                var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                Assert.IsTrue(feed != null);
                Assert.IsTrue(feed.Items.Count() == 10);
            }
            finally
            {
                TearDownSpecificUkprns();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldRejectIfMediaTypeIsAtomJson()
        {
            Assert.IsTrue(await CallEndpointAndCheckStatusCodeForMediaType("application/atom+json", HttpStatusCode.UnsupportedMediaType, FundingClaimReconciliationMostRecentPageUrl));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationAtomFeed_ShouldRejectWithBadRequest_WhenPageNumberOutRange()
        {
            string url = string.Format(FundingClaimReconciliationPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml", HttpStatusCode.NotFound, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationAtomFeed_ShouldRejectWithUnsupportedMediaType_WhenCallingWithoutAMediaType()
        {
            string url = string.Format(FundingClaimReconciliationPageSpecificUrl, -1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode.UnsupportedMediaType, url).Result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldGetLatestContractsThenWalkLinksToTheStart()
        {
            SetupDatabaseWithANumberOfRows(31);
            var response = await CallEndpointAndReturnResultAsync(_mediaType, FundingClaimReconciliationMostRecentPageUrl);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.AreEqual(1, feed.Items.Count(), "The number of items is not correct");

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
                    response = await CallEndpointAndReturnResultAsync(_mediaType, link.Uri.AbsolutePath);
                    feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                    numArchivedPages++;
                }

            } while (link != null);

            Assert.AreEqual(3, numArchivedPages);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingClaimReconciliationAtomFeed_ShouldGetFirstContractsThenWalkLinksToTheEnd()
        {
            try
            {
                TearDownSpecificUkprns();
                SetupDatabaseWithANumberOfRows(31);
                string url = string.Format(FundingClaimReconciliationPageSpecificUrl, 1);
                var response = await CallEndpointAndReturnResultAsync(_mediaType, url);
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
                        response = await CallEndpointAndReturnResultAsync(_mediaType, link.Uri.AbsolutePath);
                        feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
                        numNextPages++;
                    }

                } while (link != null && link.RelationshipType != AtomRelationship.SelfRelationship);

                Assert.IsTrue(numNextPages == 3);
            }
            finally
            {
                TearDownSpecificUkprns();
            }
        }

        #endregion

        private async Task<bool> CallEndpointAndCheckStatusCodeForMediaType(string mediaType, HttpStatusCode statusCode, string url)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));
            AddAuthorizationHeader(client);
            var result = await client.GetAsync(_baseAddress + url);
            return result.StatusCode == statusCode;
        }

        private async Task<bool> CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode statusCode, string url)
        {
            var client = new HttpClient();
            AddAuthorizationHeader(client);
            var result = await client.GetAsync(_baseAddress + url);
            return result.StatusCode == statusCode;
        }

        private async Task<string> CallEndpointAndReturnResultAsync(string mediaType, string url)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));

            AddAuthorizationHeader(client);
            HttpResponseMessage response = await client.GetAsync(_baseAddress + url);
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

        private void SetupDatabaseWithANumberOfRows(int numRows)
        {
           var payload = CreateFundingClaimReconciliationPayload();
           var connection = new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]);
           using var context = new PerformanceManagementDbContext(new ConnectionInfo(null, connection));
           int ukPrn = -5000;
           for (int i = 0; i < numRows; i++)
           {
               context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, ukPrn - i, "CTN", "AGN", "1516", payload));
               _listofUkprns.Add(ukPrn - i);
           }
           context.SaveChanges();
        }

        private string CreateFundingClaimReconciliationPayload()
        {
            var fcReconciliation = new FCReconciliation()
            {
                SchemaVersion = 1,
                FCReconciliationAllAttrs = CreateFCReconciliationAllAttrsCT()
            };

            XmlSerializer ser = new XmlSerializer(typeof(FCReconciliation));
            string xml;
            using (StringWriter sww = new StringWriter())
            {
                using (XmlWriter writer = XmlWriter.Create(sww))
                {
                    ser.Serialize(writer, fcReconciliation);
                    xml = sww.ToString(); // Your XML
                }
            }
            return xml;
        }

        private FCReconciliationAllAttrsCT CreateFCReconciliationAllAttrsCT()
        {
            return new FCReconciliationAllAttrsCT()
            {
                FCReconciliationPKeyAttrs = CreateFCReconciliationPKeyAttrsCT(),
                FCReconciliationNonPKeyAttrs = CreateFCReconciliationNonPKeyAttrsCT()
            };
        }

        private FCReconciliationPKeyAttrsCT CreateFCReconciliationPKeyAttrsCT()
        {
            return new FCReconciliationPKeyAttrsCT()
            {
                Contractor = new ContractorAllAttrsCT()
                {
                    ContractorPKeyAttrs = new ContractorPKeyAttrsCT()
                    {
                        OrganisationIdentifier = "ORG123"
                    },
                    ContractorNonPKeyAttrs = new ContractorNonPKeyAttrsCT()
                    {
                        UKPRN = 12345,
                        LegalName = "Test"
                    }
                },
                Period = new PeriodAllAttrsCT()
                {
                    PeriodTypePKeyAttrs = new PeriodTypePKeyAttrsCT()
                    {
                        PeriodTypeCode = PeriodTypeCodeST.AY
                    },
                    PeriodTypeNonPKeyAttrs = new PeriodTypeNonPKeyAttrsCT()
                    {
                        PeriodTypeName = PeriodTypeNameST.ACADEMICYEAR
                    },
                    Period = "1516"
                },
                ClaimVersionNumber = 1,
                ClaimType = new ClaimTypeAllAttrsCT()
                {
                    ClaimTypePKeyAttrs = new ClaimTypePKeyAttrsCT()
                    {
                        ClaimTypeCode = "CTC"
                    },
                    ClaimTypeNonPKeyAttrs = new ClaimTypeNonPKeyAttrsCT()
                    {
                        ClaimTypeName = "CTN"
                    }
                },
                AllocationGroup = new AllocationGroupAllAttrsCT()
                {
                    AllocationGroupPKeyAttrs = new AllocationGroupPKeyAttrsCT()
                    {
                        AllocationGroupCode = "AGC"
                    },
                    AllocationGroupNonPKeyAttrs = new AllocationGroupNonPKeyAttrsCT()
                    {
                        AllocationGroupName = "AGN"
                    }
                }
            };
        }

        private FCReconciliationNonPKeyAttrsCT CreateFCReconciliationNonPKeyAttrsCT()
        {
            return new FCReconciliationNonPKeyAttrsCT()
            {
                Status = ReconciliationStatusST.Published,
                StatusLastUpdatedDate = DateTime.UtcNow,
                AmountAttrs = new AmountAttrsCT()
                {
                    CappedClaimedValue = 1m,
                    ClaimedValue = 1m,
                    PlannedValue = 1m,
                    ProposedReconciliationValue = 1m,
                    ReconciliationValue = 1m
                },
                ContractAllocation = CreateListOfContractAllocationAllAttrsCT()
            };
        }

        private List<ContractAllocationAllAttrsCT> CreateListOfContractAllocationAllAttrsCT()
        {
            return new List<ContractAllocationAllAttrsCT>()
            {
                 new ContractAllocationAllAttrsCT()
                 {
                     ContractAllocationPKeyAttrs = new ContractAllocationPKeyAttrsCT()
                     {
                         ContractAllocationNumber = "12345"
                     },
                     ContractAllocationNonPKeyAttrs = CreateContractAllocationNonPKeyAttrsCT(),
                     ContractAllocationDNAttrs = CreateContractAllocationDNAttrsCT()
                 }
            };
        }

        private ContractAllocationDNAttrsCT CreateContractAllocationDNAttrsCT()
        {
            return new ContractAllocationDNAttrsCT()
            {
                ContractAttrs = new ContractAllAttrsCT()
                {
                    ContractNumber = "1",
                    ContractVersionNumber = 1,
                    ContractSubVersionNumber = 1,
                    FundingTypeAllAttrs = new FundingTypeAllAttrsCT()
                    {
                        FundingPKeyAttrs = new FundingTypePKeyAttrsCT()
                        {
                            FundingTypeCode = "FTC"
                        },
                        FundingTypeNonPKeyAttrs = new FundingTypeNonPKeyAttrsCT()
                        {
                            FundingTypeName = "FTN"
                        }
                    },
                    ContractApprovalDate = DateTime.UtcNow
                }
            };
        }

        private ContractAllocationNonPKeyAttrsCT CreateContractAllocationNonPKeyAttrsCT()
        {
            return new ContractAllocationNonPKeyAttrsCT()
            {
                FundingstreamPeriodCode = "FSPC",
                AllocationStartDate = DateTime.UtcNow,
                AllocationEndDate = DateTime.UtcNow.AddMonths(1),
                AmountAttrs = new AmountAttrsCT()
                {
                    CappedClaimedValue = 1m,
                    ClaimedValue = 1m,
                    PlannedValue = 1m,
                    ProposedReconciliationValue = 1m,
                    ReconciliationValue = 1m
                },
                ContractDeliverables = new List<ContractDeliverablesAllAttrsCTContractDeliverable>()
                {
                    new ContractDeliverablesAllAttrsCTContractDeliverable()
                    {
                        Deliverable = new DeliverableAllAttrsCT()
                        {
                            DeliverableCode = 1,
                            DeliverableName = "D1"
                        },
                        AmountAttrs = new AmountAttrsCT()
                        {
                            CappedClaimedValue = 1m,
                            ClaimedValue = 1m,
                            PlannedValue = 1m,
                            ProposedReconciliationValue = 1m,
                            ReconciliationValue = 1m
                        }
                    }
                }
            };
        }

        private void TearDownSpecificUkprns()
        {
            var connection = new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]);
            using var context = new PerformanceManagementDbContext(new ConnectionInfo(null, connection));
            {
                foreach (var item in context.AtomFeedItems.Where(a => _listofUkprns.Contains(a.Ukprn)))
                {
                    context.AtomFeedItems.Remove(item);
                }
                context.SaveChanges();
            }
            _listofUkprns = new List<int>();
        }

        private void TearDownAll()
        {
            var connection = new SqlConnection(new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"]);
            using var context = new PerformanceManagementDbContext(new ConnectionInfo(null, connection));
            {
                context.AtomFeedItems.ToList().ForEach(item => context.AtomFeedItems.Remove(item));

                context.SaveChanges();
            }
        }
    }
}