namespace OrganisationDomain.Implementation.Tests.BusinessLogic
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.XPath;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Implementation.BusinessLogic;
    using Implementation.Converters;
    using Integration.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CpdsStubTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CpdsStub_GetProviderByUkprn_ShouldReturnDefaultXmlWhenUkprnIsNotSpecialCase()
        {
            // arrange
            const int ukprn = 12345678;
            CpdsStub organisationRetriever = new CpdsStub(Mock.Of<ILogger>(), Mock.Of<IAzureTableStore>(), Mock.Of<ICpdsProviderConverter>());
            var namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "http://xpims.lsc.gov.uk/ProviderDataSetV2");

            // act
            var xDocument = organisationRetriever.GetProviderByUkprn(ukprn);

            // assert
            var ukprnInXml = xDocument.XPathSelectElement("//ns:UKPRN", namespaceManager);
            Assert.AreEqual(ukprn.ToString(), ukprnInXml.Value, "The ukprn is not correct");
            var tradingNameInXml = xDocument.XPathSelectElement("//ns:TradingName", namespaceManager);
            Assert.AreEqual("NACRO", tradingNameInXml.Value, "The tradingNameInXml is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CpdsStub_GetProviderByUkprn_ShouldReturnXmlForSpecialCases()
        {
            // arrange
            CpdsStub organisationRetriever = new CpdsStub(Mock.Of<ILogger>(), Mock.Of<IAzureTableStore>(), Mock.Of<ICpdsProviderConverter>());
            var namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "http://xpims.lsc.gov.uk/ProviderDataSetV2");

            List<int> specialUkprns = new List<int> { 10000000, 10009986, 10009987, 10009988, 10009989, 78900203 };
            specialUkprns.ForEach(ukprn =>
            {
                // act
                var xDocument = organisationRetriever.GetProviderByUkprn(ukprn);

                // assert
                Assert.IsNotNull(xDocument);
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CpdsStub_GetProviderByUkprnAndUpin_ShouldReturnDefaultXmlWhenUkprnIsNotSpecialCase()
        {
            // arrange
            const int ukprn = 12345678;
            CpdsStub organisationRetriever = new CpdsStub(Mock.Of<ILogger>(), Mock.Of<IAzureTableStore>(), Mock.Of<ICpdsProviderConverter>());
            var namespaceManager = new XmlNamespaceManager(new NameTable());
            namespaceManager.AddNamespace("ns", "http://xpims.lsc.gov.uk/ProviderDataSetV2");

            // act
            var xDocument = organisationRetriever.GetProviderByUkprnAndUpin(ukprn, 1234);

            // assert
            var ukprnInXml = xDocument.XPathSelectElement("//ns:UKPRN", namespaceManager);
            Assert.AreEqual(ukprn.ToString(), ukprnInXml.Value, "The ukprn is not correct");
            var tradingNameInXml = xDocument.XPathSelectElement("//ns:TradingName", namespaceManager);
            Assert.AreEqual("NACRO", tradingNameInXml.Value, "The tradingNameInXml is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ICpdsOrganisationRetriever_ShouldResolveCorrectlyForCpdsEndpoint()
        {
            // Arrange
            ConfigurationManager.AppSettings["CPDS:UseStub"] = "false";
            IWindsorContainer container = new WindsorContainer().Install(new OrganisationDomain.Integration.CpdsEndpoint.Ioc.ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // Act
            var organisationRetriever = container.Resolve<ICpdsOrganisationRetriever>();

            // Assert
            Assert.IsTrue(organisationRetriever is CpdsOrganisationRetriever);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ICpdsOrganisationRetriever_ShouldResolveCorrectlyForMainEndpoint()
        {
            // Arrange
            ConfigurationManager.AppSettings["CPDS:UseStub"] = "false";
            IWindsorContainer container = new WindsorContainer().Install(new OrganisationDomain.Integration.MainEndpoint.Ioc.ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // Act
            var organisationRetriever = container.Resolve<ICpdsOrganisationRetriever>();

            // Assert
            Assert.IsTrue(organisationRetriever is CpdsOrganisationRetriever);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ICpdsOrganisationRetriever_ShouldResolveStubCorrectlyForCpdsEndpoint()
        {
            // Arrange
            ConfigurationManager.AppSettings["CPDS:UseStub"] = "true";
            IWindsorContainer container = new WindsorContainer().Install(new OrganisationDomain.Integration.CpdsEndpoint.Ioc.ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // Act
            var organisationRetriever = container.Resolve<ICpdsOrganisationRetriever>();

            // Assert
            Assert.IsTrue(organisationRetriever is CpdsStub);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ICpdsOrganisationRetriever_ShouldResolveStubCorrectlyForMainEndpoint()
        {
            // Arrange
            ConfigurationManager.AppSettings["CPDS:UseStub"] = "true";
            IWindsorContainer container = new WindsorContainer().Install(new OrganisationDomain.Integration.MainEndpoint.Ioc.ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // Act
            var organisationRetriever = container.Resolve<ICpdsOrganisationRetriever>();

            // Assert
            Assert.IsTrue(organisationRetriever is CpdsStub);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ICpdsSummaryRetriever_ShouldResolveCorrectlyForCpdsEndpoint()
        {
            // Arrange
            ConfigurationManager.AppSettings["CPDS:UseStub"] = "false";
            IWindsorContainer container = new WindsorContainer().Install(new OrganisationDomain.Integration.CpdsEndpoint.Ioc.ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // Act
            var cpdsSummaryRetriever = container.Resolve<ICpdsSummaryRetriever>();

            // Assert
            Assert.IsTrue(cpdsSummaryRetriever is CpdsSummaryRetriever);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ICpdsSummaryRetriever_ShouldResolveCorrectlyForMainEndpoint()
        {
            // Arrange
            ConfigurationManager.AppSettings["CPDS:UseStub"] = "false";
            IWindsorContainer container = new WindsorContainer().Install(new OrganisationDomain.Integration.MainEndpoint.Ioc.ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // Act
            var cpdsSummaryRetriever = container.Resolve<ICpdsSummaryRetriever>();

            // Assert
            Assert.IsTrue(cpdsSummaryRetriever is CpdsSummaryRetriever);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ICpdsSummaryRetriever_ShouldResolveStubCorrectlyForCpdsEndpoint()
        {
            // Arrange
            ConfigurationManager.AppSettings["CPDS:UseStub"] = "true";
            IWindsorContainer container = new WindsorContainer().Install(new OrganisationDomain.Integration.CpdsEndpoint.Ioc.ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // Act
            var cpdsSummaryRetriever = container.Resolve<ICpdsSummaryRetriever>();

            // Assert
            Assert.IsTrue(cpdsSummaryRetriever is CpdsStub);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ICpdsSummaryRetriever_ShouldResolveStubCorrectlyForMainEndpoint()
        {
            // Arrange
            ConfigurationManager.AppSettings["CPDS:UseStub"] = "true";
            IWindsorContainer container = new WindsorContainer().Install(new OrganisationDomain.Integration.MainEndpoint.Ioc.ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // Act
            var cpdsSummaryRetriever = container.Resolve<ICpdsSummaryRetriever>();

            // Assert
            Assert.IsTrue(cpdsSummaryRetriever is CpdsStub);
        }

        [TestMethod, TestCategory("Exploratory")]
        public void CpdsStub_GetProviderByUkprn_ShouldReadFromAzureTableStorage()
        {
            // arrange
            CpdsStub stub = new CpdsStub(Mock.Of<ILogger>(), new AzureTableStore(), new CpdsProviderConverter());

            // act
            XDocument xml = stub.GetProviderByUkprn(40020001);

            // assert
            Assert.IsNotNull(xml);
        }

        [TestMethod, TestCategory("Exploratory")]
        public void CpdsStub_RetrieveSummary_ShouldReadFromXmlResource()
        {
            // arrange
            CpdsStub stub = new CpdsStub(Mock.Of<ILogger>(), new AzureTableStore(), new CpdsProviderConverter());

            // act
            List<ProviderSequence> providers = stub.RetrieveSummary();

            // assert
            Assert.IsTrue(providers.Any());
        }
    }
}
