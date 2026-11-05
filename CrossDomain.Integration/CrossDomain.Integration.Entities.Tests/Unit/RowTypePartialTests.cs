namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    public class RowTypePartialTests
    {
        private enum Colour
        {
            Red,
            DarkBlue
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellValue_ReturnsValueForMatchingColumn()
        {
            var row = Row(("A", "hello"), ("B", "world"));

            Assert.AreEqual("world", row.GetCellValue("B"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellValue_MissingOrEmpty_ReturnsNull()
        {
            var row = Row(("A", ""), ("B", null));

            Assert.IsNull(row.GetCellValue("A"));
            Assert.IsNull(row.GetCellValue("B"));
            Assert.IsNull(row.GetCellValue("Z"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellInt_ParsesWholeNumbers()
        {
            var row = Row(("A", "42"), ("B", "7.0"));

            Assert.AreEqual(42, row.GetCellInt("A"));
            Assert.AreEqual(7, row.GetCellInt("B"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellInt_InvalidOrFractionOrMissing_ReturnsZero()
        {
            var row = Row(("A", "abc"), ("B", "1.5"));

            Assert.AreEqual(0, row.GetCellInt("A"));
            Assert.AreEqual(0, row.GetCellInt("B"));
            Assert.AreEqual(0, row.GetCellInt("Z"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellNullableInt_ReturnsValueOrNull()
        {
            var row = Row(("A", "12"), ("B", "1.5"), ("C", "x"));

            Assert.AreEqual(12, row.GetCellNullableInt("A"));
            Assert.IsNull(row.GetCellNullableInt("B"));
            Assert.IsNull(row.GetCellNullableInt("C"));
            Assert.IsNull(row.GetCellNullableInt("Z"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellDecimal_ReturnsValueOrZero()
        {
            var row = Row(("A", "12.5"), ("B", "x"));

            Assert.AreEqual(12.5m, row.GetCellDecimal("A"));
            Assert.AreEqual(0m, row.GetCellDecimal("B"));
            Assert.AreEqual(0m, row.GetCellDecimal("Z"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellNullableDecimal_ReturnsValueOrNull()
        {
            var row = Row(("A", "12.5"), ("B", "x"));

            Assert.AreEqual(12.5m, row.GetCellNullableDecimal("A"));
            Assert.IsNull(row.GetCellNullableDecimal("B"));
            Assert.IsNull(row.GetCellNullableDecimal("Z"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellDateTime_ParsesUkFormat()
        {
            var row = Row(("A", "25/12/2019"), ("B", "2019-12-25"));

            Assert.AreEqual(new DateTime(2019, 12, 25, 0, 0, 0, DateTimeKind.Utc), row.GetCellDateTime("A"));
            Assert.IsNull(row.GetCellDateTime("B"));
            Assert.IsNull(row.GetCellDateTime("Z"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetDateTime_NullOrInvalid_ReturnsNull()
        {
            var row = Row();

            Assert.IsNull(row.GetDateTime(null));
            Assert.IsNull(row.GetDateTime("31/02/2019"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellEnum_ParsesStrippingSpacesOrReturnsDefault()
        {
            var row = Row(("A", "Dark Blue"), ("B", "Red"), ("C", "Purple"));

            Assert.AreEqual(Colour.DarkBlue, row.GetCellEnum("A", Colour.Red));
            Assert.AreEqual(Colour.Red, row.GetCellEnum("B", Colour.DarkBlue));
            Assert.AreEqual(Colour.DarkBlue, row.GetCellEnum("C", Colour.DarkBlue));
            Assert.AreEqual(Colour.DarkBlue, row.GetCellEnum("Z", Colour.DarkBlue));
        }

        private static rowType Row(params (string Column, string Value)[] cells)
        {
            var row = new rowType { cell = new cellType[cells.Length] };
            for (var i = 0; i < cells.Length; i++)
            {
                row.cell[i] = new cellType { columnName = cells[i].Column, Value = cells[i].Value };
            }

            return row;
        }
    }
}
