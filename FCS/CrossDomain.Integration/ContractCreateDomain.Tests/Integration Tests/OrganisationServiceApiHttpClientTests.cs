namespace ContractCreateDomain.Tests.Integration_Tests
{
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Model;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class OrganisationServiceApiHttpClientTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationServiceApiHttpClient_ShouldReturnAnOrganisationForAnActiveUkprn()
        {
            const int testUkprn = 12345678;

            // arrange
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Organisations.RemoveWhere(o => o.Ukprn == testUkprn);
                context.Organisations.RemoveWhere(o => o.Upin == testUkprn);
                context.Organisations.Add(new Organisation
                {
                    Ukprn = testUkprn,
                    Upin = testUkprn,
                    TradingName = testUkprn.ToString()
                });
                context.SaveChanges();
            }

            IWindsorContainer container = new WindsorContainer()
                .Install(new Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
            container.BeginScope();

            IOrganisationServiceApiHttpClient organisationServiceApiHttpClient = container.Resolve<IOrganisationServiceApiHttpClient>();

            // act
            HttpResponseMessage httpResponse = organisationServiceApiHttpClient.GetHttpResponseForUkprn(testUkprn);

            // assert
            Assert.IsNotNull(httpResponse, "HTTP response was null");
            Assert.AreEqual(HttpStatusCode.OK, httpResponse.StatusCode, "Unexpected HTTP status code returned");

            string content = httpResponse.Content.ReadAsStringAsync().Result;

            XmlSerializer serializer = new XmlSerializer(typeof(organisation));
            using (XmlReader reader = XElement.Parse(content).CreateReader())
            {
                organisation returnedOrganisation = (organisation)serializer.Deserialize(reader);
                Assert.AreEqual(testUkprn.ToString(), returnedOrganisation.organisationIdentifiers.Single(o => o.organisationIdentifierType == organisationIdentifierType.UKPROVIDERREFERENCENUMBER).organisationIdentifier, "Expected Organisation not returned in XML");
            }
        }
    }
}