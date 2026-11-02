using System;
using Aspose.Words.MailMerging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.DocumentsDomain.Integration;

namespace SFA.FCT.DocumentsDomain.UnitTests.ResourceLayer
{
    [TestClass]
    public class MergeDataSourceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeDataSourceCTOR()
        {
            MergeDataSource mds = new MergeDataSource("TestTable");
            Assert.AreEqual("TestTable", mds.TableName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeDataSourceAddRegionMergeField()
        {
            MergeDataSource mds = new MergeDataSource("TestTable");
            mds.AddRegionMergeField(0, "TestTable", 0, "MergeField1Name", "MergeField1Value");

            Assert.IsTrue(mds.MoveNext());
            object value;
            Assert.IsTrue(mds.GetValue("MergeField1Name", out value));
            Assert.AreEqual("MergeField1Value", (string)value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeDataSourceAskingForNonExistantChildTable()
        {
            MergeDataSource mds = new MergeDataSource("TestTable");
            mds.AddRegionMergeField(0, "TestTable", 0, "MergeField1Name", "MergeField1Value");

            Assert.IsTrue(mds.MoveNext());
            Assert.IsNull(mds.GetChildDataSource("ReturnsNull"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeDataSourceAskingForNonExistantField()
        {
            MergeDataSource mds = new MergeDataSource("TestTable");
            mds.AddRegionMergeField(0, "TestTable", 0, "MergeField1Name", "MergeField1Value");

            Assert.IsTrue(mds.MoveNext());
            object value = "ShouldBeSetToNull";
            Assert.IsFalse(mds.GetValue("MergeField2Name", out value));
            Assert.IsNull(value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeDataSourceAskingForFieldBeforeMoveNext()
        {
            MergeDataSource mds = new MergeDataSource("TestTable");
            mds.AddRegionMergeField(0, "TestTable", 0, "MergeField1Name", "MergeField1Value");

            object value = "ShouldBeSetToNull";
            Assert.IsFalse(mds.GetValue("MergeField1Name", out value));
            Assert.IsNull(value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestMergeDataSourceAddSubRegionMergeField()
        {
            MergeDataSource mds = new MergeDataSource("TestTable");
            mds.AddRegionMergeField(0, "TestTable", 0, "MergeField1Name", "MergeField1Value");
            mds.AddRegionMergeField(0, "SubTable", 0, "SubTableMergeField1Name", "SubTableMergeField1Value");

            Assert.IsTrue(mds.MoveNext());
            object value;
            Assert.IsTrue(mds.GetValue("MergeField1Name", out value));
            Assert.AreEqual("MergeField1Value", (string)value);

            IMailMergeDataSource subTable = mds.GetChildDataSource("SubTable");
            Assert.IsNotNull(subTable);
            Assert.IsInstanceOfType(subTable, typeof (MergeDataSource));
            Assert.IsTrue(subTable.MoveNext());
            Assert.IsTrue(subTable.GetValue("SubTableMergeField1Name", out value));
            Assert.AreEqual("SubTableMergeField1Value", (string) value);
            Assert.IsFalse(subTable.MoveNext());

            Assert.IsFalse(mds.MoveNext());
        }

    }
}
