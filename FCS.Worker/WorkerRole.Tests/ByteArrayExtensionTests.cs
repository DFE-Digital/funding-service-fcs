namespace WorkerRole.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;

    [TestClass]
    public class ByteArrayExtensionTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ByteArrayExtensions_ShouldIdentifyWhenBytesAreZipped()
        {
            // arrange
            const string testString = "Test123";

            var zippedBytes = ZipHelper.ToZippedBytesFromString(testString);

            // act assert
            Assert.IsTrue(zippedBytes.IsZipped());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ByteArrayExtensions_ShouldIdentifyWhenBytesAreNotZipped()
        {
            // arrange
            const string testString = "Test123";

            var bytes = testString.ConvertObjectToByteArray();

            // act and assert
            Assert.IsFalse(bytes.IsZipped());
        }
    }
}
