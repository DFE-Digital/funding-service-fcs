namespace CrossDomain.Integration.Common.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

    [TestClass]
    public class AzureStorageKeyEncoderTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Calling_Encode_Replaces_Disallowed_Characters_With_Underscores()
        {
            Assert.AreEqual("UDC-1234-5678", AzureStorageKeyEncoder.Encode("UDC-1234-5678"));
            Assert.AreEqual("UDC_1234_5678", AzureStorageKeyEncoder.Encode("UDC/1234\\5678"));
            Assert.AreEqual("UDC_1234_5678", AzureStorageKeyEncoder.Encode("UDC#1234?5678"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Calling_Encode_Removes_Control_Characters()
        {
            Assert.AreEqual("UDC-1234-5678", AzureStorageKeyEncoder.Encode("UDC-\t1234-\r5678"));
        }
    }
}
