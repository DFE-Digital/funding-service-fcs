namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System;
    using System.Collections.Generic;
    using Calculation.Dtos;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CensusPeriodInfosExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CensusPeriodInfosExtensions_ShouldGetCurrent()
        {
            // arrange
            IList<CensusPeriodInfo> censusPeriodInfos = new List<CensusPeriodInfo>
            {
                new CensusPeriodInfo(new DateTime(2019, 12, 09, 22, 0, 0, DateTimeKind.Utc),
                    11, 2019),
                new CensusPeriodInfo(new DateTime(2020, 01, 09, 22, 0, 0, DateTimeKind.Utc),
                    12, 2019),
                new CensusPeriodInfo(new DateTime(2020, 02, 10, 22, 0, 0, DateTimeKind.Utc),
                    1, 2020),
                new CensusPeriodInfo(new DateTime(2020, 03, 09, 22, 0, 0, DateTimeKind.Utc),
                    2, 2020),
            };
            
            // act
            CensusPeriodInfo current =
                censusPeriodInfos.GetCurrent(new DateTime(2020, 02, 04, 10, 0, 0, DateTimeKind.Utc));

            // assert
            Assert.AreEqual(202001, current.GetPeriod(), "the period is wrong");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CensusPeriodInfosExtensions_ShouldReturnCurrentDateWhenThereAreNoCensusDates()
        {
            // arrange
            IList<CensusPeriodInfo> censusPeriodInfos = new List<CensusPeriodInfo>();

            // act
            CensusPeriodInfo current =
                censusPeriodInfos.GetCurrent(new DateTime(2020, 02, 04, 10, 0, 0, DateTimeKind.Utc));

            // assert
            Assert.AreEqual(current.GetPeriod(), 202002);
        }
    }
}
