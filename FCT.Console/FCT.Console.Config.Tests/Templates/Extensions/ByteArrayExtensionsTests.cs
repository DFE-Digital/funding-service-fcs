namespace FCT.Console.Config.Tests.Templates.Extensions
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Security.Cryptography;
    using FCT.Console.Config.Templates.Extensions;

    [TestClass]
    public class ByteArrayExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ByteArray_GetTemplateDocumentToUploadChecksum_ShouldProduceChecksum()
        {
            // arrange
            var dummyFileByteArray = new MemoryStream(Encoding.UTF8.GetBytes("This is a dummy file")).ToArray();

            // act 
            var assertCheckSum = dummyFileByteArray.GetTemplateDocumentToUploadChecksum();

            // assert
            var expectedCheckSum = new byte[16];
            using (var md5 = MD5.Create())
            {
                expectedCheckSum = md5.ComputeHash(dummyFileByteArray);
            }

            Assert.IsTrue(expectedCheckSum.SequenceEqual(assertCheckSum));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ByteArray_TemplateDocumentHasNotAlreadyBeenAdded_ShouldReturnTrue()
        {
            // arrange
            var dummyFileByteArray = new MemoryStream(Encoding.UTF8.GetBytes("This is a dummy file")).ToArray();

            var checkSum = new byte[16];
            using (var md5 = MD5.Create())
            {
                checkSum = md5.ComputeHash(dummyFileByteArray);
            }

            // act 
            var assertResponse = checkSum.TemplateDocumentHasNotAlreadyBeenAdded();

            // assert
            Assert.IsFalse(assertResponse);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ByteArray_TemplateDocumentHasNotAlreadyBeenAdded_ShouldReturnFalse()
        {
            // arrange
            byte[] checkSum = null;

            // act 
            var assertResponse = checkSum.TemplateDocumentHasNotAlreadyBeenAdded();

            // assert
            Assert.IsTrue(assertResponse);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ByteArray_ChecksumsAreNotTheSame_ShouldReturnTrue()
        {
            // arrange
            var checksumFirst = Encoding.ASCII.GetBytes("Same");
            var checksumSecond = Encoding.ASCII.GetBytes("Different");

            // act 
            var assertResponse = checksumFirst.ChecksumsAreNotTheSame(checksumSecond);

            // assert
            Assert.IsTrue(assertResponse);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ByteArray_ChecksumsAreNotTheSame_ShouldReturnFalse()
        {
            // arrange
            var checksumFirst = Encoding.ASCII.GetBytes("Same");
            var checksumSecond = Encoding.ASCII.GetBytes("Same");

            // act 
            var assertResponse = checksumFirst.ChecksumsAreNotTheSame(checksumSecond);

            // assert
            Assert.IsFalse(assertResponse);
        }
    }
}