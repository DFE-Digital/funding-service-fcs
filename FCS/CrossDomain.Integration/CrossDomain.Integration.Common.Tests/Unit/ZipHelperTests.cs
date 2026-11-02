namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;

    [TestClass]
    public class ZipHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ZipHelper_ShouldTransformStringToZippedBytesAndBack()
        {
            const string testString = "Test123";

            var zippedBytes = ZipHelper.ToZippedBytesFromString(testString);

            Assert.AreEqual(testString, ZipHelper.ToStringFromZippedBytes(zippedBytes));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ZipHelper_ShouldZipBytes()
        {
            const string testString = "Test123";

            // act
            var zippedBytes = ZipHelper.ToZippedBytesFromBytes(testString.ConvertObjectToByteArray());

            // assert
            string unzippedStr = ZipHelper.ToStringFromZippedBytes(zippedBytes);

            Assert.AreEqual(testString, unzippedStr);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void ZipHelper_ShouldUnZipBytes()
        {
            const string testString = "Test123";
            var zippedBytes = ZipHelper.ToZippedBytesFromBytes(testString.ConvertObjectToByteArray());

            // act
            byte[] unzippedBytes = ZipHelper.ToBytesFromZippedBytes(zippedBytes);

            Assert.IsTrue(testString.ConvertObjectToByteArray().SequenceEqual(unzippedBytes));
        }
    }
}
