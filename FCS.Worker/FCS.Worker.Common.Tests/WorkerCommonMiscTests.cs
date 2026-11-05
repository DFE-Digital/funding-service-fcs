using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCS.Worker.Common;
using SFA.FCS.Worker.Common.Serialization;
using SFA.FCS.Worker.Common.Slack;

namespace SFA.FCS.Worker.Common.Tests
{
    [TestClass]
    public class ConnectionInfoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateDefault_UsesDefault()
        {
            var info = ConnectionInfo.CreateDefault();

            Assert.IsTrue(info.UseDefault());
            Assert.IsNull(info.Connection);
            Assert.IsNull(info.Transaction);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateFromConnectionString_BuildsSqlConnectionWithoutTransaction()
        {
            var info = ConnectionInfo.CreateFrom("Server=localhost;Database=x");

            Assert.IsFalse(info.UseDefault());
            Assert.IsNotNull(info.Connection);
            Assert.IsNull(info.Transaction);
            Assert.AreEqual("Server=localhost;Database=x", info.Connection.ConnectionString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateFromDbConnection_KeepsConnection()
        {
            using (var connection = new System.Data.SqlClient.SqlConnection("Server=a"))
            {
                var info = ConnectionInfo.CreateFrom(connection);

                Assert.AreSame(connection, info.Connection);
                Assert.IsFalse(info.UseDefault());
            }
        }
    }

    [TestClass]
    public class SlackDictionaryExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetValueIfPresent_Dictionary_ReturnsValueOrNull()
        {
            IDictionary<string, string> dictionary = new Dictionary<string, string> { { "a", "1" } };

            Assert.AreEqual("1", dictionary.GetValueIfPresentOtherwiseNull("a"));
            Assert.IsNull(dictionary.GetValueIfPresentOtherwiseNull("b"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetValueIfPresent_ReadOnlyDictionary_ReturnsValueOrNull()
        {
            IReadOnlyDictionary<string, string> dictionary = new Dictionary<string, string> { { "a", "1" } };

            Assert.AreEqual("1", dictionary.GetValueIfPresentOtherwiseNull("a"));
            Assert.IsNull(dictionary.GetValueIfPresentOtherwiseNull("b"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetTextAndValueIfPresent_FormatsKeyAndValue()
        {
            IReadOnlyDictionary<string, string> dictionary = new Dictionary<string, string> { { "k", "v" } };

            Assert.AreEqual("k : v", dictionary.GetTextAndValueIfPresent("k"));
            Assert.IsNull(dictionary.GetTextAndValueIfPresent("missing"));
        }
    }

    [TestClass]
    public class ByteArraySerializerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ConvertToByteArray_SerializableObject_ReturnsBytes()
        {
            var bytes = ByteArraySerializer.ConvertToByteArray("hello");

            Assert.IsTrue(bytes.Length > 0);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FrameworkConfiguration_UnknownKey_ReturnsNull()
        {
            var configuration = new FrameworkConfiguration();

            Assert.IsNull(configuration["ConnectionStrings:DoesNotExist"]);
            Assert.IsNull(configuration["DoesNotExist"]);
        }
    }
}
