namespace FCT.Console.Config.Tests.Templates.Extensions
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Linq;
    using System.Collections.Generic;
    using System.Text;
    using FCT.Console.Config.Templates.Extensions;
    using SFA.FCT.DocumentsDomain.DataStore.Models;

    [TestClass]
    public class UploadedDocumentTemplatesExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ByteArray_GetExistingTemplateDocumentCheckSum_ShouldReturnCorrectCheckSum()
        {
            // arrange
            const string expected = "expected";
            var expectedCheckSum = Encoding.ASCII.GetBytes(expected);

            IEnumerable<UploadedDocumentTemplate> uploadedDocumentTemplates = new List<UploadedDocumentTemplate>
            {
                new UploadedDocumentTemplate("random1", Encoding.ASCII.GetBytes("random1"), DateTime.Now),
                new UploadedDocumentTemplate(expected, expectedCheckSum, DateTime.Now),
                new UploadedDocumentTemplate("random2", Encoding.ASCII.GetBytes("random2"), DateTime.Now)
            };

            // act 
            var assertCheckSum= uploadedDocumentTemplates.GetExistingTemplateDocumentCheckSum(expected);

            // assert
            Assert.IsTrue(expectedCheckSum.SequenceEqual(assertCheckSum));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ByteArray_GetFilenamesToRemove_ShouldReturnCorrectFilenames()
        {
            // arrange
            const string expected1 = "expected1";
            const string expected2 = "expected2";
            var expectedFilenames = new List<string> { expected1, expected2 };
            var expectedCheckSum = Encoding.ASCII.GetBytes("expected");

            IEnumerable<UploadedDocumentTemplate> uploadedDocumentTemplates = new List<UploadedDocumentTemplate>
            {
                new UploadedDocumentTemplate("random1", Encoding.ASCII.GetBytes("random1"), DateTime.Now),
                new UploadedDocumentTemplate(expected1, Encoding.ASCII.GetBytes(expected1), DateTime.Now),
                new UploadedDocumentTemplate(expected2, Encoding.ASCII.GetBytes(expected2), DateTime.Now),
                new UploadedDocumentTemplate("random2", Encoding.ASCII.GetBytes("random2"), DateTime.Now)
            };

            var fileNamesToUpload = new List<string> {"random1", "random2"};

            // act 
            var assertFilenamesToRemove= uploadedDocumentTemplates.GetFilenamesToRemove(fileNamesToUpload).ToList();

            // assert
            Assert.AreEqual(2, assertFilenamesToRemove.Count(), "Incorrect number of filenames returned");

            Assert.IsTrue(assertFilenamesToRemove.All(filenameToRemove => expectedFilenames.Contains(filenameToRemove)), 
                "Incorrect filenames returned");
        }
    }
}