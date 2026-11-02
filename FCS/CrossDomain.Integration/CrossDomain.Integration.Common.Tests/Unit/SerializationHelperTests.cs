using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.CrossDomain.Integration.Common.Serializers;

namespace CrossDomain.Integration.Common.Tests.Unit
{
    [TestClass]
    public class SerializationHelperTests
    {
        //private string xml = @"<?xml version=""1.0""?><XmlTest xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema""><A>a</A><B>b</B></XmlTest>";

        private string xml = "<?xml version=\"1.0\"?><XmlTest xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">  <A>a</A>  <B>b</B></XmlTest>";
        [TestMethod]
        [TestCategory("UnitTest")]
        public void SerializeToXmlTest()
        {
            var objecToSerialize = new XmlTest { A = "a", B = "b" };
            var result = SerializationHelper.SerializeToXml(objecToSerialize);
            Assert.AreEqual(xml, result.Replace("\r\n", string.Empty));
        }

        [TestMethod]
        [TestCategory("UnitTest")]
        public void DeserializeXmlTest()
        {
            var result = SerializationHelper.DeserializeXml<XmlTest>(xml);
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
