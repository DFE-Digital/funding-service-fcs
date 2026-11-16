namespace OrganisationDomain.Web.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Formatting;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using System.Web.Http;
    using Integration.DataStore;
    using Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common.Authentication;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;
    using UnitTests.Common;
    using System.Configuration;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;

    [TestClass]
    public class OrganisationServiceIntegrationTests
    {
        // These correspond to the stubbed CDPS data files
        private const string InvalidOrgId = "ORG10000000";

        private const string InvalidXmlOrgUkprn = "99990087";

        private const string ValidUkprnInCache = "12345678";
        private const string ValidUkprnNotInCache = "10009986";
        private const string InvalidUkPrnNotInCache = "10000000";

        private const string DuplicateProvidersWithNumericUpinsAndOneIsActive = "99990001"; // 200 - Found
        private const string DuplicateProvidersWithNumericUpinsAndNoneAreActive = "99990002"; // 404 - Not Found
        private const string DuplicateProvidersThatAreActiveAndBothHaveNumericUpins = "99990004"; //400 - Bad Request
        private const string DuplicateProvidersThatAreActiveAndBothHaveNonNumericUpins = "99990005"; //404 - Not Found

        private const string GetOrgByOrgIdUri = "api/v1/organisations/";
        private const string GetOrgByUkprnUri = "api/v1/organisations/ukprn/";

        public HttpClient Connection { get; private set; }

        public XmlMediaTypeFormatter XmlFormatter { get; set; }

        [TestInitialize]
        public void SetupOrganisationService()
        {
            var orgServiceUri = Properties.Settings.Default["OrganisationServiceUri"].ToString();

            var client = new HttpClient()
            {
                BaseAddress = new Uri(orgServiceUri),
            };

            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer",
                AzureAuthenticator.GetAuthenticationResult("OrgService"));

            Connection = client;

            //Use Xml Serializer
            XmlFormatter = GlobalConfiguration.Configuration.Formatters.XmlFormatter;
            XmlFormatter.UseXmlSerializer = true;
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByUkPrn_WhenUkPrnExistsInDBReturnsValidResponse()
        {
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync(GetOrgByUkprnUri + ValidUkprnInCache);

                // Assert
                if (response.StatusCode == HttpStatusCode.NotFound)
                {
                    Assert.Fail($"Organisation with UkPrn {ValidUkprnInCache} was not found in the Database");
                }
                else if (!response.IsSuccessStatusCode)
                {
                    Assert.Fail(
                        $"There was a problem communicating with the Organisation Service - the response was: {response.Content}");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByUkPrn_ShouldNotBringBackUnintentionalHttpHeaders()
        {
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage httpResponseMessage = await client.GetAsync(GetOrgByUkprnUri + ValidUkprnInCache);

                // assert
                Assert.IsFalse(httpResponseMessage.Headers.Contains("X-Powered-By"), "The headers should not contain 'X-Powered-By'");
                Assert.IsFalse(httpResponseMessage.Headers.Contains("X-AspNet-Version"), "The headers should not contain 'X-AspNet-Version'");
                Assert.IsTrue(httpResponseMessage.Headers.Server.Empty(), "The Server items in the header should be empty");
            }
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByUkPrn_ShouldBringBackSecurityHttpHeaders()
        {
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage httpResponseMessage = await client.GetAsync(GetOrgByUkprnUri + ValidUkprnInCache);

                // assert
                var securityHeaders = new List<(string headerKey, string value)>
                {
                    ("X-Frame-Options", "SAMEORIGIN"),
                    ("X-XSS-Protection", "0"),
                    ("X-Content-Type-Options", "nosniff"),
                    // ("Strict-Transport-Security", "max-age=3600;"),
                    ("Content-Security-Policy", "default-src 'self'"),
                };

                securityHeaders.ForEach(securityHeader =>
                {
                    httpResponseMessage.Headers.TryGetValues(securityHeader.headerKey, out var headerValues);
                    headerValues = headerValues ?? new List<string>();

                    Assert.IsTrue(headerValues.Any(), $"The header: {securityHeader.headerKey} is not present");
                    Assert.AreEqual( securityHeader.value, headerValues.Single(),
                        $"The header: {securityHeader.headerKey} has the wrong value");
                });
            }
        }

        [TestMethod, TestCategory("IntegrationTestWIP")]
        public async Task GetOrgByUkPrn_WhenUkPrnExistsInDBReturnsValidResponseAppService()
        {
            var orgServiceUri = "https://fcs-dev-dat-app-org-webapi.azurewebsites.net/";

            var httpClient = new HttpClient()
            {
                BaseAddress = new Uri(orgServiceUri),
            };

            httpClient.DefaultRequestHeaders.Accept.Clear();
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));
          //  ConfigurationManager.AppSettings[$"ida:ResourceId_OrgService"] = "793c81b6-fe51-4247-9ca7-1ce11367d586";

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer",
                AzureAuthenticator.GetAuthenticationResult("OrgService"));

            Connection = httpClient;

            //Use Xml Serializer
            XmlFormatter = GlobalConfiguration.Configuration.Formatters.XmlFormatter;
            XmlFormatter.UseXmlSerializer = true;

            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync(GetOrgByUkprnUri + ValidUkprnInCache);

                // Assert
                if (response.StatusCode == HttpStatusCode.NotFound)
                {
                    Assert.Fail($"Organisation with UkPrn {ValidUkprnInCache} was not found in the Database");
                }
                else if (!response.IsSuccessStatusCode)
                {
                    Assert.Fail($"There was a problem communicating with the Organisation Service - the response was: {response.Content}");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByUkPrn_WhenUkPrnDoesNotExistInDBButInWebServiceReturnsValidResponse()
        {
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync(GetOrgByUkprnUri + ValidUkprnNotInCache);

                // Assert
                if (response.StatusCode == HttpStatusCode.NotFound)
                {
                    Assert.Fail($"Organisation with UKPrn {ValidUkprnNotInCache} was not found in cache");
                }
                else if (!response.IsSuccessStatusCode)
                {
                    Assert.Fail($"There was a problem communicating with the Organisation Service - the response was: {response.Content}");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByUkPrn_WhenUkPrnDoesNotExistInDBAndNotInWebServiceReturnsNotFound()
        {
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync(GetOrgByUkprnUri + InvalidUkPrnNotInCache);

                // Assert
                if (response.IsSuccessStatusCode)
                {
                    Assert.Fail("Success code was returned for an invalid UkPrn");
                }
                else if (response.StatusCode != HttpStatusCode.NotFound)
                {
                    Assert.Fail($"There was a problem communicating with the Organisation Service - the response was: {response.Content}");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByUkPrn_WhenDuplicateProvidersWithNumericUpinsExistInCPDS_AndOneOfThemIsActive_ThenTheActiveOneIsReturnedWithASuccessResponseCode()
        {
            //UKPRN of 99990001
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync(GetOrgByUkprnUri + DuplicateProvidersWithNumericUpinsAndOneIsActive);
                var organisation = response.Content.ReadAsAsync<organisation>(new Collection<MediaTypeFormatter>() {XmlFormatter}).Result;

                // Assert
                Assert.IsTrue(response.StatusCode == HttpStatusCode.OK, "Status Code of 200 was not returned");
                Assert.IsTrue(organisation.organisationStatusRelationships[0].organisationStatus.organisationStatus == "Active", "The 'Active' provider was not returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByOrgId_WhenOrgIdExistsInDBReturnsValidResponse()
        {
            // Arrange
            string validOrgId = GetFirstOrganisationId();

            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync(GetOrgByOrgIdUri + validOrgId);

                // Assert
                if (response.StatusCode == HttpStatusCode.NotFound)
                {
                    Assert.Fail($"Organisation {validOrgId} was not found in the Database");
                }
                else if (!response.IsSuccessStatusCode)
                {
                    Assert.Fail($"There was a problem communicating with the Organisation Service - the response was: {response.Content}");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByOrgId_WhenOrgIdDoesNotExistInDBReturnsNotFoundResponse()
        {
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync(GetOrgByOrgIdUri + InvalidOrgId);

                // Assert
                if (response.IsSuccessStatusCode)
                {
                    Assert.Fail("Success code was returned for an invalid Organisation Id");
                }
                else if (response.StatusCode != HttpStatusCode.NotFound)
                {
                    Assert.Fail($"There was a problem communicating with the Organisation Service - the response was: {response.Content}");
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByUkPrn_ShouldReturnXmlThatsPassesValidationAgainstTheCorporateSchema()
        {
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync(GetOrgByUkprnUri + "99990001");
                var organisation = response.Content.ReadAsAsync<organisation>(new Collection<MediaTypeFormatter>() { XmlFormatter }).Result;

                //Assert
                List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();
                Assert.IsTrue(organisation.IsOrganisationXmlValid(out validationErrors),"The returned Xml was not valid");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task GetOrgByUpin_ShouldReturnXmlThatsPassesValidationAgainstTheCorporateSchema()
        {
            const int ukprn = 12345678;
            string orgId;

            // arrange
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Organisations.RemoveWhere(o => o.Ukprn == ukprn || o.Upin == ukprn);

                Organisation org = new Organisation
                {
                    Ukprn = ukprn,
                    Upin = ukprn,
                    TradingName = ukprn.ToString(),
                    Status = "Active",
                    Type = "Org Type"
                };
                context.Organisations.Add(org);
                context.SaveChanges();

                orgId = org.FormattedOrganisationId;
            }

            using (HttpClient client = Connection)
            {
                HttpResponseMessage response = await client.GetAsync(GetOrgByOrgIdUri + orgId);
                organisation organisation = response.Content.ReadAsAsync<organisation>(new Collection<MediaTypeFormatter> { XmlFormatter }).Result;

                // act
                organisation.IsOrganisationXmlValid(out var validationErrors);

                // assert
                Assert.IsFalse(validationErrors.Any(), string.Join("\n", validationErrors.Select(e => e.ErrorMessage)));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task OrganisationService_ShouldGetAnOkWhenCallingTheTestEndpoint()
        {
            // Arrange
            using (HttpClient client = Connection)
            {
                // Act
                HttpResponseMessage response = await client.GetAsync("/api/v1/test");
                ;

                //Assert
                Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task OrgService_GetOrgByUkprn_ShouldReturnAddressInResponseWhenAddressIsPresentInOrgService()
        {
            const int ukprn = 12345678;

            // arrange
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Organisations.RemoveWhere(o => o.Ukprn == ukprn || o.Upin == ukprn);
                context.Organisations.Add(new Organisation
                {
                    Ukprn = ukprn,
                    Upin = ukprn,
                    TradingName = ukprn.ToString(),
                    Status = "Active",
                    Type = "Org Type",
                    Address = new Address
                    {
                        Line1 = "Line1",
                        Line2 = "Line2",
                        Line3 = "Line3",
                        Line4 = "Line4",
                        Town = "Town",
                        County = "County",
                        Postcode = "Postcode"
                    }
                });
                context.SaveChanges();
            }

            // act
            using (HttpClient client = Connection)
            {
                HttpResponseMessage response = await client.GetAsync(GetOrgByUkprnUri + ukprn);
                organisation organisation = response.Content.ReadAsAsync<organisation>(new Collection<MediaTypeFormatter> { XmlFormatter }).Result;

                // assert
                Assert.AreEqual(1, organisation.organisationAddresses.Count, "Unexpected number of addresses returned");
                Assert.AreEqual("Line1", organisation.organisationAddresses[0].addressLine1, "Unexpected addressLine1 returned");
                Assert.AreEqual("Line2", organisation.organisationAddresses[0].addressLine2, "Unexpected addressLine2 returned");
                Assert.AreEqual("Line3", organisation.organisationAddresses[0].addressLine3, "Unexpected addressLine3 returned");
                Assert.AreEqual("Line4", organisation.organisationAddresses[0].addressLine4, "Unexpected addressLine4 returned");
                Assert.AreEqual("Town", organisation.organisationAddresses[0].town, "Unexpected town returned");
                Assert.AreEqual("County", organisation.organisationAddresses[0].county, "Unexpected county returned");
                Assert.AreEqual("Postcode", organisation.organisationAddresses[0].postcode, "Unexpected postcode returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task OrgService_GetOrgByUkprn_ShouldNotReturnAnyAddressInResponseWhenAddressIsNotPresentInOrgService()
        {
            const int ukprn = 12345678;

            // arrange
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Organisations.RemoveWhere(o => o.Ukprn == ukprn || o.Upin == ukprn);
                context.Organisations.Add(new Organisation
                {
                    Ukprn = ukprn,
                    Upin = ukprn,
                    TradingName = ukprn.ToString(),
                    Status = "Active",
                    Type = "Org Type",
                });
                context.SaveChanges();
            }

            // act
            using (HttpClient client = Connection)
            {
                HttpResponseMessage response = await client.GetAsync(GetOrgByUkprnUri + ukprn);
                organisation organisation = response.Content.ReadAsAsync<organisation>(new Collection<MediaTypeFormatter> { XmlFormatter }).Result;

                // assert
                Assert.IsFalse(organisation.organisationAddresses.Any(), "Unexpected addresses returned");
            }
        }

        [TestCleanup]
        public void DisposeOrganisationService()
        {
            Connection.Dispose();
        }

        private static string GetFirstOrganisationId()
        {
            using (OrganisationDomainDbContext dbContext = new OrganisationDomainDbContext())
            {
                return dbContext.Organisations
                    .OrderBy(o => o.OrganisationId)
                    .First()
                    .FormattedOrganisationId;
            }
        }
    }
}