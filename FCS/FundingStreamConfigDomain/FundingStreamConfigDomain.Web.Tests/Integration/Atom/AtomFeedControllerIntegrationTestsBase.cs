namespace FundingStreamConfigDomain.Web.Tests.Integration.Atom
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Reflection;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Atom;

    public abstract class AtomFeedControllerIntegrationTestsBase
    {
        private static readonly XsdSchemaInfo[] XsdSchemas =
        {
            new XsdSchemaInfo
            {
                AssemblyName = "CrossDomain.Integration.Entities.dll",
                EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.FundingPolicy.funding_policy_corporate_schema.xsd",
                SchemaNamespace = "urn:sfa:schemas:funding-policy"
            },
            new XsdSchemaInfo
            {
                AssemblyName = "CrossDomain.Integration.Entities.dll",
                EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.FundingPolicy.funding_policy_api_schema.xsd",
                SchemaNamespace = "urn:sfa:apis:funding-policy"
            }
        };

        protected abstract string PageSpecificUrl { get; }

        protected abstract string MostRecentPageUrl { get; }

        protected abstract string VendorAtomMediaType { get; }

        private static string BaseAddress => new AppConfiguration()["FundingPolicyUrl"];

        protected void ShouldRejectWithMediaTypeNotSupported_WhenEndpointCalledWithUnsupportedMediaType()
        {
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeForMediaType("application/json", HttpStatusCode.UnsupportedMediaType, MostRecentPageUrl).Result);
        }

        protected void ShouldNotReject_IfMediaTypeIsAtomXml()
        {
            Assert.IsTrue(CallEndpointAndCheckStatusCodeForMediaType("application/atom+xml", HttpStatusCode.OK, MostRecentPageUrl).Result);
        }

        protected async Task ShouldReturnCorrectContentTypesForNextPrevLinks()
        {
            var url = string.Format(PageSpecificUrl, 2);
            var response = await CallEndpointAndReturnResultAsync(VendorAtomMediaType, url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));

            Assert.IsNotNull(feed);
            Assert.AreEqual(
                VendorAtomMediaType,
                feed.Links.First(li => li.RelationshipType == AtomRelationship.PreviousRelationship).MediaType);
            Assert.AreEqual(
                VendorAtomMediaType,
                feed.Links.First(li => li.RelationshipType == AtomRelationship.NextRelationship).MediaType);
        }

        protected async Task ShouldReturnASyndicationFeedForTheCurrentPageWithNoNextLink()
        {
            var url = MostRecentPageUrl;
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));
            Assert.IsNotNull(feed);
            Assert.AreEqual(0, feed.Links.Count(li => li.RelationshipType == AtomRelationship.NextRelationship), "We have returned a next link for the current page");
        }

        protected void ShouldReject_IfMediaTypeIsAtomJson()
        {
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeForMediaType("application/atom+json", HttpStatusCode.UnsupportedMediaType, MostRecentPageUrl).Result);
        }

        protected void ShouldRejectWithUnsupportedMediaType_WhenCallingWithoutAMediaType()
        {
            var url = string.Format(PageSpecificUrl, 1);
            Assert.IsTrue(
                CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode.UnsupportedMediaType, url).Result);
        }

        protected async Task ShouldReturnEntriesThatValidateAgainstXsd()
        {
            var url = string.Format(PageSpecificUrl, 2);
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url);
            var feed = SyndicationFeed.Load(new XmlTextReader(new StringReader(response)));

            Assert.IsNotNull(feed);

            foreach (var item in feed.Items)
            {
                Assert.IsInstanceOfType(item.Content, typeof(XmlSyndicationContent));

                var xml = GetXmlFromSyndicationContent((XmlSyndicationContent)item.Content);
                var xsdErrors = GetXsdValidationErrors(xml);
                Assert.IsFalse(xsdErrors.Any(), string.Join("\n", xsdErrors));
            }
        }


        private static async Task<bool> CallEndpointAndCheckStatusCodeForMediaType(string mediaType, HttpStatusCode statusCode, string url)
        {
            using (var client = GetAuthorizedHttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(mediaType));
                var result = await client.GetAsync(BaseAddress + url);
                return result.StatusCode == statusCode;
            }
        }

        private static async Task<bool> CallEndpointAndCheckStatusCodeWithoutMediaType(HttpStatusCode statusCode, string url)
        {
            using (var client = GetAuthorizedHttpClient())
            {
                var result = await client.GetAsync(BaseAddress + url);
                return result.StatusCode == statusCode;
            }
        }

        private static async Task<string> CallEndpointAndReturnResultAsync(string mediaType, string url,
            TestContext context = null)
        {
            return await CallEndpointAndReturnResultAsyncForFullUrl(mediaType, BaseAddress + url,context);
        }

        private static async Task<string> CallEndpointAndReturnResultAsyncForFullUrl(string mediaType, string url,
            TestContext context = null)
        {
            using (var client = GetAuthorizedHttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(mediaType));
                context?.WriteLine(url + " : " + mediaType);
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

        private static string GetXmlFromSyndicationContent(XmlSyndicationContent content)
        {
            using (var reader = content.GetReaderAtContent())
            {
                return reader.ReadInnerXml();
            }
        }

        private static string[] GetXsdValidationErrors(string xml)
        {
            var errors = new List<string>();
            var xDoc = XDocument.Parse(xml);
            var schemas = GetXmlSchemaSet();

            xDoc.Validate(schemas, (sender, e) =>
            {
                errors.Add(e.Message);
            });

            return errors.ToArray();
        }

        private static XmlSchemaSet GetXmlSchemaSet()
        {
            var schemas = new XmlSchemaSet();

            foreach (var xsdSchema in XsdSchemas)
            {
                using (var stream = Assembly.LoadFrom(xsdSchema.AssemblyName).GetManifestResourceStream(xsdSchema.EmbeddedResourceName))
                {
                    if (stream != null)
                    {
                        schemas.Add(xsdSchema.SchemaNamespace, new XmlTextReader(stream));
                    }
                }
            }

            return schemas;
        }

        private class XsdSchemaInfo
        {
            public string AssemblyName { get; set; }

            public string EmbeddedResourceName { get; set; }

            public string SchemaNamespace { get; set; }
        }
    }
}
