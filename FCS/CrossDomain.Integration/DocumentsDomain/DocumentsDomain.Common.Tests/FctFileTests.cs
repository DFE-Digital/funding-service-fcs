using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.DocumentsDomain.Common.Models;

namespace DocumentsDomain.Common.Tests
{
    [TestClass]
    public class FctFileTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TestFctFileDefaultCTOR()
        {
            FctFile file = new FctFile();
            Assert.IsNull(file.FileContainer);
            Assert.IsNull(file.FileContainer);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestFctFileCTORWithParams()
        {
            FctFile file = new FctFile("file-container", "file-name");
            Assert.AreEqual("file-container", file.FileContainer);
            Assert.AreEqual("file-name", file.Filename);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestFctFileGetHashCode()
        {
            FctFile file = new FctFile("file-container", "file-name");

            Assert.AreEqual("file-containerfile-name".GetHashCode(), file.GetHashCode());
        }
    }
}
