namespace CrossDomain.Integration.Common.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

    [TestClass]
    public class StorageObjectSerializerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldSerializeAndDeserializeSimpleObject()
        {
            StorageObjectSerializer serializer = new StorageObjectSerializer();

            string test = "Some string";
            byte[] bytes = serializer.Serialize(test);

            string s = serializer.Deserialize<string>(bytes);

            Assert.IsTrue(test == s);
        }
    }
}
