namespace PerformanceManagementDomain.Tests.ReconciliationPublication.Extensions
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationPublication.Extensions;

    [TestClass]
    public class SerializationExtensionsTests
    {
        private const string xml = "<?xml version=\"1.0\"?><XmlTest xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">  <A>a</A>  <B>b</B></XmlTest>";

        [TestMethod, TestCategory("UnitTest")]
        public void SerializeToXml_ShouldSerialize()
        {
            // arrange
            XmlTest objectToSerialize = new XmlTest { A = "a", B = "b" };

            // act
            string result = objectToSerialize.SerializeToXml();

            // assert
            Assert.AreEqual(xml, result.Replace("\r\n", string.Empty));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeserializeXml_ShouldDeserialize()
        {
            // act
            var result = xml.DeserializeXml<XmlTest>();

            // assert
            Assert.AreEqual("a", result.A);
            Assert.AreEqual("b", result.B);
        }

        public class XmlTest
        {
            public string A { get; set; }

            public string B { get; set; }
        }
    }
}
