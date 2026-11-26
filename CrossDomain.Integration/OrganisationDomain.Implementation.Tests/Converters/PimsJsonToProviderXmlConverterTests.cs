using Microsoft.VisualStudio.TestTools.UnitTesting;
using OrganisationDomain.Implementation.Converters;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace OrganisationDomain.Implementation.Tests.Converters
{
    [TestClass]
    public class PimsJsonToProviderXmlConverterTests
    {
        private PimsJsonToProviderXmlConverter _sut;

        [TestInitialize]
        public void Setup()
        {
            _sut = new PimsJsonToProviderXmlConverter();
        }

        [TestMethod]
        public void Convert_Should_Return_Valid_Xml()
        {
            // Arrange
            var json = File.ReadAllText(@"TestData\ProviderByUkprn.json");

            // Act
            var result = _sut.Convert(json);

            // Assert
            Assert.IsNotNull(result);
            Assert.IsNotNull(result.Root);  
        }
        [TestMethod]
        public void Convert_Should_Map_Ukprn()
        {
            // Arrange

            var json = File.ReadAllText(@"TestData\ProviderByUkprn.json");

            var converter =
                new PimsJsonToProviderXmlConverter();

            // Act

            var result = converter.Convert(json);

            XNamespace ns =
                "http://xpims.lsc.gov.uk/ProviderDataSetV2";

            // Assert

            Assert.AreEqual(
                "50000001",
                result.Descendants(ns + "UKPRN")
                      .First()
                      .Value);


        }
        [TestMethod]
        public void Convert_Should_Map_Upin()
        {
            var json = File.ReadAllText(@"TestData\ProviderByUkprn.json");
            var converter =
                new PimsJsonToProviderXmlConverter();

            var result = converter.Convert(json);

            XNamespace ns =
                "http://xpims.lsc.gov.uk/ProviderDataSetV2";

            Assert.AreEqual(
                "105008",
                result.Descendants(ns + "Upin")
                      .First()
                      .Value);

            var provider =
    result.Root.Element(ns + "Provider");

            Assert.AreEqual(
                "1004069",
                provider.Attribute("ProviderSequenceNumber").Value);
            Assert.AreEqual(
    "Private Provider",
    result.Descendants(ns + "ProviderType")
          .Last()
          .Value);
            Assert.AreEqual(
    "Active",
    result.Descendants(ns + "CodeValueDesc")
          .Single()
          .Value);
        }
        [TestMethod]
        public void Convert_Should_Return_XDocument()
        {
            // Arrange
            var json = File.ReadAllText(@"TestData\ProviderByUkprn.json");


            var converter = new PimsJsonToProviderXmlConverter();

            // Act
            var result = converter.Convert(json);

            // Assert
            Assert.IsNotNull(result);
        }
         
    }
}
