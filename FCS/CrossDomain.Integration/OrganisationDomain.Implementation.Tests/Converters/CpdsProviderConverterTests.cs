using Microsoft.VisualStudio.TestTools.UnitTesting;
using OrganisationDomain.Implementation.Converters;

namespace OrganisationDomain.Implementation.Tests.Converters
{
    [TestClass]
    public class CpdsProviderConverterTests
    {
        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod,TestCategory("UnitTest")]
        public void ConvertXmlToProviders_ShouldExtractUkPrnAndSequenceNumberAndUPin()
        {
            var converter = new CpdsProviderConverter();
            
            converter.CpdsXml = 
                "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                  "<Provider ProviderSequenceNumber='741101'>" +
                   " <Upin>002</Upin>"+
                   " <UKPRN>12345678</UKPRN>"+
                   " <TradingName>National Employer Service</TradingName>"+
                 " </Provider>"+
                 " <Provider ProviderSequenceNumber='610288'>"+
                  "  <Upin>003</Upin>"+
                  " <UKPRN>0</UKPRN>"+
                  "  <TradingName>National Apprenticeship Service</TradingName>"+
                  "</Provider>"+
                  "</ProviderDataSetV2>";
            var Providers = converter.ConvertXmlToProviders();

            Assert.IsTrue(Providers[0].Ukprn == 12345678 
                && Providers[0].SequenceNumber == 741101
                && Providers[0].Upin == 002,
                "ConvertXmlToProviders did not extract the correct fields for provider sequence");
        }
        [TestMethod, TestCategory("UnitTest")]
        public void ConvertXmlToProviders_ShouldOnlyExtractProvidersWithUKPRNNotZero()
        {
            var converter = new CpdsProviderConverter();

            converter.CpdsXml =
                "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                  "<Provider ProviderSequenceNumber='741101'>" +
                   " <Upin>002</Upin>" +
                   " <UKPRN>12345678</UKPRN>" +
                   " <TradingName>National Employer Service</TradingName>" +
                 " </Provider>" +
                 " <Provider ProviderSequenceNumber='610288'>" +
                  "  <Upin>003</Upin>" +
                  " <UKPRN>0</UKPRN>" +
                  "  <TradingName>National Apprenticeship Service</TradingName>" +
                  "</Provider>" +
                  "</ProviderDataSetV2>";
            var Providers = converter.ConvertXmlToProviders();

            Assert.IsTrue(Providers.Count == 1, "ConvertXmlToProviders did not return correct number of providers");
        }
        [TestMethod, TestCategory("UnitTest")]
        public void ConvertXmlToProviders_ShouldOnlyExtractProvidersWithUPinInteger()
        {
            var converter = new CpdsProviderConverter();

            converter.CpdsXml =
                "<ProviderDataSetV2 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://xpims.lsc.gov.uk/ProviderDataSetV2'>" +
                  "<Provider ProviderSequenceNumber='741101'>" +
                   " <Upin>002</Upin>" +
                   " <UKPRN>12345678</UKPRN>" +
                   " <TradingName>National Employer Service</TradingName>" +
                 " </Provider>" +
                 " <Provider ProviderSequenceNumber='610288'>" +
                  "  <Upin>xxx</Upin>" +
                  " <UKPRN>12345679</UKPRN>" +
                  "  <TradingName>National Apprenticeship Service</TradingName>" +
                  "</Provider>" +
                  "</ProviderDataSetV2>";
            var Providers = converter.ConvertXmlToProviders();

            Assert.IsTrue(Providers.Count == 1, "ConvertXmlToProviders did not return correct number of providers");
        }
        [TestMethod, TestCategory("UnitTest")]
        public void ConvertXmlToProviders_ShouldReturnNull_WhenNoXml()
        {
            var converter = new CpdsProviderConverter();

            converter.CpdsXml = "";
            var Providers = converter.ConvertXmlToProviders();

            Assert.IsNull(Providers, "ConvertXmlToProviders did not return null");
        }

        
    }
}
