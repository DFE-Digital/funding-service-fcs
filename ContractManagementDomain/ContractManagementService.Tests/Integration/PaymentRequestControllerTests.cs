namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Xml;
    using System.Xml.Serialization;
    using CrossDomain.Integration.Common.Extensions;
    using global::ContractManagementService.Tests;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using SFA.FCT.ContractManagementService.Test.Utils;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    [TestClass]
    public class PaymentRequestControllerTests
    {
        private const int PageSizeOfFeed = 2;
        private const string ApplicationUrl = "/api/AllocationDelivery/payment-requests/notifications";

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentRequestController_ShouldGetOkStatusCodeWhenLatestUrlHit_WithBearerToken()
        {
            // arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{ApplicationUrl}";

            // act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var result = client.GetAsync(url).Result;
                returnedStatusCode = result.StatusCode;
            }

            // assert
            Assert.AreEqual(HttpStatusCode.OK, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentRequestController_ShouldGetUnauthorizedStatusCodeWhenLatestUrlHit_WithoutBearerToken()
        {
            // arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{ApplicationUrl}";

            // act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                client.DefaultRequestHeaders.Authorization = null;
                returnedStatusCode = client.GetAsync(url).Result.StatusCode;
            }

            // assert
            Assert.AreEqual(HttpStatusCode.Unauthorized, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentRequestController_ShouldGetPartialPageOfItemsWhenLatestUrlHit()
        {
            // arrange
            string url = $"{GetBaseUrl()}{ApplicationUrl}";
            ClearAtomItemFeedTable();
            const int numItemsInPartialPage = 1;
            AddItemsToFeedTable(numberOfItems: numItemsInPartialPage);

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                string feedXml = client.GetAsync(url).Result.Content.ReadAsStringAsync().Result;
                SyndicationFeed feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(feedXml)));

                // assert
                Assert.IsTrue(feed != null, "The feed is null");
                Assert.AreEqual(numItemsInPartialPage, feed.Items.Count(), "The number of items on the latest ");
                Assert.AreEqual(1, feed.Links.Count, "The number of links is not correct");
                var prevLink = feed.Links.FirstOrDefault(l => l.RelationshipType == "prev-archive");
                Assert.IsNull(prevLink, "The prev-archive link is there");
                var selfLink = feed.Links.FirstOrDefault(l => l.RelationshipType == "self");
                Assert.IsNotNull(selfLink, "The self link is not there");
                Assert.AreEqual($"{GetBaseUrl()}{ApplicationUrl}", selfLink.Uri.AbsoluteUri, "The self link url is incorrect");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentRequestController_ShouldGetFullPageOfItemsWhenLatestUrlHit()
        {
            // arrange
            string url = $"{GetBaseUrl()}{ApplicationUrl}";
            ClearAtomItemFeedTable();
            AddItemsToFeedTable(numberOfItems: 2 * PageSizeOfFeed);

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                string feedXml = client.GetAsync(url).Result.Content.ReadAsStringAsync().Result;
                SyndicationFeed feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(feedXml)));

                // assert
                Assert.IsTrue(feed != null, "The feed is null");
                Assert.AreEqual(PageSizeOfFeed, feed.Items.Count(), "The number of items on the latest");
                Assert.AreEqual(2, feed.Links.Count, "The number of links is not correct");
                var selfLink = feed.Links.FirstOrDefault(l => l.RelationshipType == "self");
                Assert.IsNotNull(selfLink, "The self link is not there");
                Assert.AreEqual($"{url}", selfLink.Uri.AbsoluteUri, "The self link url is incorrect");
                var prevLink = feed.Links.FirstOrDefault(l => l.RelationshipType == "prev-archive");
                Assert.IsNotNull(prevLink, "The prev-archive link is not there");
                Assert.AreEqual($"{url}/1", prevLink.Uri.AbsoluteUri, "The prev-archive link url is incorrect");
                PaymentPeriod firstPaymentPeriodOnFeed = TranslateSyndicationItemToPaymentPeriod(feed.Items.First());
                Assert.AreEqual("2", firstPaymentPeriodOnFeed.FinancialPaymentFinancialMonth, "The payment periods have not come back in the rigth order (the month is wrong)");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentRequestController_ShouldGetFullPageOfItemsWhenPage1UrlHit()
        {
            // arrange
            string url = $"{GetBaseUrl()}{ApplicationUrl}/1";
            ClearAtomItemFeedTable();
            AddItemsToFeedTable(numberOfItems: PageSizeOfFeed + 1);

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                string feedXml = client.GetAsync(url).Result.Content.ReadAsStringAsync().Result;
                SyndicationFeed feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(feedXml)));

                // assert
                Assert.IsTrue(feed != null, "The feed is null");
                Assert.AreEqual(PageSizeOfFeed, feed.Items.Count(), "The number of items on the latest");
                Assert.AreEqual(2, feed.Links.Count, "The number of links is not correct");
                var selfLink = feed.Links.FirstOrDefault(l => l.RelationshipType == "self");
                Assert.IsNotNull(selfLink, "The self link is not there");
                Assert.AreEqual($"{GetBaseUrl()}{ApplicationUrl}", selfLink.Uri.AbsoluteUri, "The self link url is incorrect");
                var prevLink = feed.Links.FirstOrDefault(l => l.RelationshipType == "prev-archive");
                Assert.IsNull(prevLink, "The prev-archive link is there");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentRequestController_ShouldNotBringBackUnintentionalHttpHeaders()
        {
            // arrange
            string url = $"{GetBaseUrl()}{ApplicationUrl}";

            // act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var httpResponseMessage = client.GetAsync(url).Result;

                // act
                Assert.IsFalse(httpResponseMessage.Headers.Contains("X-Powered-By"), "The headers should not contain 'X-Powered-By'");
                Assert.IsFalse(httpResponseMessage.Headers.Contains("X-AspNet-Version"), "The headers should not contain 'X-AspNet-Version'");
                Assert.IsTrue(httpResponseMessage.Headers.Server.Empty(), "The Server items in the header should be empty");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentRequestController_ShouldBringBackSecurityHttpHeaders()
        {
            // arrange
            string url = $"{GetBaseUrl()}{ApplicationUrl}";

            // act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var httpResponseMessage = client.GetAsync(url).Result;

                // act
                // assert
                var securityHeaders = new List<(string headerKey, string value)>
                {
                    ("X-Frame-Options", "SAMEORIGIN"),
                    ("X-XSS-Protection", "0"),
                    ("X-Content-Type-Options", "nosniff"),
                    ("Strict-Transport-Security", "max-age=63072000; includeSubdomains; preload"),
                    ("Content-Security-Policy", "default-src 'self'"),
                };

                securityHeaders.ForEach(securityHeader =>
                {
                    httpResponseMessage.Headers.TryGetValues(securityHeader.headerKey, out var headerValues);
                    headerValues = headerValues ?? new List<string>();

                    Assert.IsTrue(headerValues.Any(), $"The header: {securityHeader.headerKey} is not present");
                    Assert.AreEqual(securityHeader.value, headerValues.Single(),  $"The header: {securityHeader.headerKey} has the wrong value");
                });
            }
        }

        private PaymentPeriod TranslateSyndicationItemToPaymentPeriod(SyndicationItem item)
        {
            string itemXml = GetFeedItemXml(item);

            return DeserializeItemToPaymentPeriod(itemXml);
        }

        private static HttpClient GetAuthorizedHttpClient(string mediaType = "application/vnd.sfa.paymentrequests.v1+atom+xml")
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));


           client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
            return client;
        }

        private static string GetBaseUrl()
        {
            return new AppConfiguration()["ContractManagementServiceUrl"];
        }

        private string GetFeedItemXml(SyndicationItem item)
        {
            XmlWriterSettings ws = new XmlWriterSettings
            {
                Indent = true,
                IndentChars = " ",
                OmitXmlDeclaration = true,
                Encoding = new UTF8Encoding()
            };

            XmlSyndicationContent content = (XmlSyndicationContent)item.Content;

            MemoryStream ms = new MemoryStream();
            XmlWriter w = XmlWriter.Create(ms, ws);
            content.WriteTo(w, "Content", "");
            w.Flush();
            ms.Position = 0;
            StreamReader sr = new StreamReader(ms);
            return sr.ReadToEnd();
        }

        private PaymentPeriod DeserializeItemToPaymentPeriod(string xmlContent)
        {
            xmlContent = StripOffOuterElement(xmlContent);

            MemoryStream ms = new MemoryStream();

            StreamWriter sw = new StreamWriter(ms);
            sw.WriteLine(xmlContent);
            sw.Flush();

            ms.Position = 0;

            XmlSerializer xs = new XmlSerializer(typeof(PaymentPeriod));
            return xs.Deserialize(ms) as PaymentPeriod;
        }

        private static string StripOffOuterElement(string xmlContent)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xmlContent);

            return doc.FirstChild.FirstChild.OuterXml;
        }

        private static void ClearAtomItemFeedTable()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.Database.Connection.ConnectionString =
                    new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"];
                context.PaymentBatchFeedItems.ToList().ForEach(fi => context.PaymentBatchFeedItems.Remove(fi));

                context.SaveChanges();
            }
        }

        private static void AddItemsToFeedTable(int numberOfItems)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.Database.Connection.ConnectionString =
                    new AppConfiguration()["ConnectionStrings:ContractManagementDbContext"];
                Enumerable.Range(0, numberOfItems).ToList().ForEach(i =>
                    {
                        context.PaymentBatchFeedItems.Add(CreatePaymentBatchFeedItem(i));
                    });
                context.PaymentBatchFeedItems.ToList().ForEach(fi => context.PaymentBatchFeedItems.Remove(fi));

                context.SaveChanges();
            }
        }

        private static PaymentBatchFeedItem CreatePaymentBatchFeedItem(int month)
        {
            return PaymentBatchFeedItem.Create(new PaymentPeriod
            {
                PaymentDetails = new List<PaymentDetail>(),
                FinancialPaymentFinancialMonth = month.ToString(),
                FinancialPaymentFinancialYear = "2018",
                CensusEndDate = DateTime.Now,

            }, "FSP", "LC");
        }
    }
}
