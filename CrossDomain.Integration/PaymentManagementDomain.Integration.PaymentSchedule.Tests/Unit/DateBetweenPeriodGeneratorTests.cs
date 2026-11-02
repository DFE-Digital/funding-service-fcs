namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Core.Internal;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration;

    [TestClass]
    public class DateBetweenPeriodGeneratorTests
    {
        [ExpectedException(typeof (ArgumentOutOfRangeException))]
        [TestMethod, TestCategory("UnitTest")]
        public void DateBetweenPeriodGenerator_GetPeriodsBetweenTwoDates_ShouldThrowException_WhenGivenAStartDateLaterThanEndDate()
        {
            // Arrange
            DateTime startDateTime = new DateTime(2018, 2, 1);
            DateTime endDateTime = new DateTime(2018, 1, 1);

            // Act
            DateBetweenPeriodGenerator.GetPeriodsBetweenTwoDates(startDateTime, endDateTime);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateBetweenPeriodGenerator_GetPeriodsBetweenTwoDates_ShouldReturnCorrectPeriods_WhenStartDateSameYearAsEndDate()
        {
            // Arrange
            string[] expectedPeriods = {
                "Jan-18",
                "Feb-18",
                "Mar-18",
                "Apr-18"
            };

            DateTime startDateTime = new DateTime(2018, 1, 1);
            DateTime endDateTime = new DateTime(2018, 4, 30);

            // Act
            IList<string> periodsBetweenTwoDates = DateBetweenPeriodGenerator.GetPeriodsBetweenTwoDates(startDateTime, endDateTime);

            // Assert
            Assert.AreEqual(expectedPeriods.Length, periodsBetweenTwoDates.Count, "Unexpected number of periods returned");
            expectedPeriods.ForEach(p =>
            {
                Assert.IsTrue(periodsBetweenTwoDates.Contains(p), $"List of periods did not contain period: {p}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateBetweenPeriodGenerator_GetPeriodsBetweenTwoDates_ShouldReturnCorrectPeriods_WhenEndDateOneYearAfterStart()
        {
            // Arrange
            string[] expectedPeriods = {
                "Feb-18",
                "Mar-18",
                "Apr-18",
                "May-18",
                "Jun-18",
                "Jul-18",
                "Aug-18",
                "Sep-18",
                "Oct-18",
                "Nov-18",
                "Dec-18",
                "Jan-19"
            };

            DateTime startDateTime = new DateTime(2018, 2, 1);
            DateTime endDateTime = new DateTime(2019, 1, 1);

            // Act
            IList<string> periodsBetweenTwoDates = DateBetweenPeriodGenerator.GetPeriodsBetweenTwoDates(startDateTime, endDateTime);

            // Assert
            Assert.AreEqual(expectedPeriods.Length, periodsBetweenTwoDates.Count(), "Unexpected number of periods returned");
            expectedPeriods.ForEach(p =>
            {
                Assert.IsTrue(periodsBetweenTwoDates.Contains(p), $"List of periods did not contain period: {p}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateBetweenPeriodGenerator_GetPeriodsBetweenTwoDates_ShouldReturnCorrectPeriods_WhenDateRangeRepresentsAcademicYearAllocation()
        {
            // Arrange
            string[] expectedPeriods = {
                "Sep-17",
                "Oct-17",
                "Nov-17",
                "Dec-17",
                "Jan-18",
                "Feb-18",
                "Mar-18",
                "Apr-18",
                "May-18",
                "Jun-18",
                "Jul-18",
                "Aug-18"
            };

            DateTime startDateTime = new DateTime(2017, 9, 1);
            DateTime endDateTime = new DateTime(2018, 8, 31);

            // Act
            IList<string> periodsBetweenTwoDates = DateBetweenPeriodGenerator.GetPeriodsBetweenTwoDates(startDateTime, endDateTime);

            // Assert
            Assert.AreEqual(expectedPeriods.Length, periodsBetweenTwoDates.Count, "Unexpected number of periods returned");
            expectedPeriods.ForEach(p =>
            {
                Assert.IsTrue(periodsBetweenTwoDates.Contains(p), $"List of periods did not contain period: {p}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateBetweenPeriodGenerator_GetPeriodsBetweenTwoDates_ShouldReturnCorrectPeriods_WhenDateRangeRepresentsCalendarYearAllocation()
        {
            // Arrange
            string[] expectedPeriods = {
                "Jan-17",
                "Feb-17",
                "Mar-17",
                "Apr-17",
                "May-17",
                "Jun-17",
                "Jul-17",
                "Aug-17",
                "Sep-17",
                "Oct-17",
                "Nov-17",
                "Dec-17"
            };

            DateTime startDateTime = new DateTime(2017, 1, 1);
            DateTime endDateTime = new DateTime(2017, 12, 31);

            // Act
            IList<string> periodsBetweenTwoDates = DateBetweenPeriodGenerator.GetPeriodsBetweenTwoDates(startDateTime, endDateTime);

            // Assert
            Assert.AreEqual(expectedPeriods.Length, periodsBetweenTwoDates.Count, "Unexpected number of periods returned");
            expectedPeriods.ForEach(p =>
            {
                Assert.IsTrue(periodsBetweenTwoDates.Contains(p), $"List of periods did not contain period: {p}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateBetweenPeriodGenerator_GetPeriodsBetweenTwoDates_ShouldReturnCorrectPeriods_WhenDateRangeRepresentsFinancialYearAllocation()
        {
            // Arrange
            string[] expectedPeriods = {
                "Apr-17",
                "May-17",
                "Jun-17",
                "Jul-17",
                "Aug-17",
                "Sep-17",
                "Oct-17",
                "Nov-17",
                "Dec-17",
                "Jan-18",
                "Feb-18",
                "Mar-18",
            };

            DateTime startDateTime = new DateTime(2017, 4, 1);
            DateTime endDateTime = new DateTime(2018, 3, 31);

            // Act
            IList<string> periodsBetweenTwoDates = DateBetweenPeriodGenerator.GetPeriodsBetweenTwoDates(startDateTime, endDateTime);

            // Assert
            Assert.AreEqual(expectedPeriods.Length, periodsBetweenTwoDates.Count, "Unexpected number of periods returned");
            expectedPeriods.ForEach(p =>
            {
                Assert.IsTrue(periodsBetweenTwoDates.Contains(p), $"List of periods did not contain period: {p}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateBetweenPeriodGenerator_GetPeriodsBetweenTwoDates_ShouldReturnCorrectPeriods_WhenDateRangeRepresentsShortAllocationEndingInDecember()
        {
            // Arrange
            string[] expectedPeriods = {
                "Aug-17",
                "Sep-17",
                "Oct-17",
                "Nov-17",
                "Dec-17"
            };

            DateTime startDateTime = new DateTime(2017, 8, 1);
            DateTime endDateTime = new DateTime(2017, 12, 31);

            // Act
            IList<string> periodsBetweenTwoDates = DateBetweenPeriodGenerator.GetPeriodsBetweenTwoDates(startDateTime, endDateTime);

            // Assert
            Assert.AreEqual(expectedPeriods.Length, periodsBetweenTwoDates.Count, "Unexpected number of periods returned");
            expectedPeriods.ForEach(p =>
            {
                Assert.IsTrue(periodsBetweenTwoDates.Contains(p), $"List of periods did not contain period: {p}");
            });
        }
    }
}
