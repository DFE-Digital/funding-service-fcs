using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.DocumentsDomain.Common;
using SFA.FCT.DocumentsDomain.Common.Models;

namespace DocumentsDomain.Common.Tests
{
    [TestClass]
    public class MergeFieldTypeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeFieldTypeDefaultCTOR()
        {
            MergeFieldType mft = new MergeFieldType();
            Assert.IsNull(mft.Name);
            Assert.IsNull(mft.Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeFieldTypeCTORWithParams()
        {
            MergeFieldType mft = new MergeFieldType("mft-name", "mft-value");
            Assert.AreEqual("mft-name", mft.Name);
            Assert.AreEqual("mft-value", mft.Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeFieldTypeToString()
        {
            MergeFieldType mft = new MergeFieldType("mft-name", "mft-value");
            Assert.AreEqual("MergeField Name:\"mft-name\" Value:\"mft-value\"", mft.ToString());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeFieldType_SuccessfullyTestMakeBold()
        {
            // Arrage
            MergeFieldType mft = new MergeFieldType("Name", "Value");

            // Act
            mft.MakeValueBold();

            // Assert
            Assert.AreEqual(Constants.BoldTextMarker + "Value" + Constants.EndOfTextMarker, mft.Value,
                "Make Bold did not work");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeFieldType_ShouldMakeValueEmpryWhenZero()
        {
            // Arrage
            MergeFieldType mft = new MergeFieldType("Name", "0.00");

            // Act
            mft.RemoveValueIfZero();

            // Assert
            Assert.AreEqual(String.Empty, mft.Value, "The value is not empty");
        }
    }
}
