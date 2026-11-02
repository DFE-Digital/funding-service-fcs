namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;

    [TestClass]
    public class DateTimeExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DateTimeExtensions_CallingToTSqlString_WithUtcKind_ReturnsCorrectlyFormattedString()
        {
            var dt = new DateTime(2015, 08, 15, 9, 45, 30, 250, DateTimeKind.Utc);
            var isoString = dt.ToSqlServerCompatibleString();
            Assert.AreEqual("2015-08-15T09:45:30", isoString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateTimeExtensions_CallingToTSqlString_WithLocalKindInsideDstChange_ReturnsCorrectlyFormattedString()
        {
            var dt = new DateTime(2015, 08, 15, 9, 45, 30, 250, DateTimeKind.Local);
            var isoString = dt.ToSqlServerCompatibleString();
            Assert.AreEqual("2015-08-15T09:45:30", isoString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateTimeExtensions_CallingToTSqlString_WithLocalKindOutsideDstChange_ReturnsCorrectlyFormattedString()
        {
            var dt = new DateTime(2015, 11, 15, 9, 45, 30, 250, DateTimeKind.Local);
            var isoString = dt.ToSqlServerCompatibleString();
            Assert.AreEqual("2015-11-15T09:45:30", isoString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateTimeExtensions_CallingToTSqlString_WithUnspecifiedKind_ReturnsCorrectlyFormattedString()
        {
            var dt = new DateTime(2015, 08, 15, 9, 45, 30, 250, DateTimeKind.Unspecified);
            var isoString = dt.ToSqlServerCompatibleString();
            Assert.AreEqual("2015-08-15T09:45:30", isoString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateTimeExtensions_CallingToTSqlString_WithMinValue_ReturnsCorrectlyFormattedString()
        {
            var dt = DateTime.MinValue;
            var isoString = dt.ToSqlServerCompatibleString();
            Assert.AreEqual("1753-01-01T00:00:00", isoString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateTimeExtensions_CallingToTSqlString_WithMinValuePlusOneSecond_ReturnsCorrectlyFormattedString()
        {
            var dt = DateTime.MinValue.AddSeconds(1);
            var isoString = dt.ToSqlServerCompatibleString();
            Assert.AreEqual("1753-01-01T00:00:00", isoString);
        }
    }
}
