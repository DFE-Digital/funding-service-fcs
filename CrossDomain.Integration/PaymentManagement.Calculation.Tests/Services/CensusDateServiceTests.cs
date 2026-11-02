namespace PaymentManagement.Calculation.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using Calculation.Dtos;
    using Calculation.Repositories;
    using Calculation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class CensusDateServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CensusDateService_GetCensusPeriodInfo_ShouldGetPeriodFromPaymentTimetable_ForNonPaidExternal()
        {
            // arrange
            const int calendarPeriod = 8;
            const int year = 2020;
            Mock<IPaymentTimetableRepository> paymentTimetableRepositoryMock = new Mock<IPaymentTimetableRepository>();
            paymentTimetableRepositoryMock.Setup(r => r.GetCensusPeriodInfo(It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()))
                .Returns(new CensusPeriodInfo(DateTime.Now, calendarPeriod, year));
            Mock<IDateService> dateServiceMock = new Mock<IDateService>();
            dateServiceMock.Setup(s => s.GetCurrentDate()).Returns(new DateTime());

            Mock<IPolicyFundingStreamPeriodRepository> fspRepository = new Mock<IPolicyFundingStreamPeriodRepository>();
            fspRepository
                .Setup(r => r.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(PaymentMethod.PayOnActuals);

            CensusDateService censusDateService = new CensusDateService(paymentTimetableRepositoryMock.Object, dateServiceMock.Object, fspRepository.Object);
            
            // act
            var censusPeriodInfo = censusDateService.GetCensusPeriodInfo("some fsp", ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(year, censusPeriodInfo.Year, "The year is not right");
            Assert.AreEqual(calendarPeriod, censusPeriodInfo.CalendarPeriod, "The CalendarPeriod is not right");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CensusDateService_GetCensusPeriodInfo_ShouldGetPeriodAsDateBeforePaymentTimetableStarts_WhenCurrentDateIsBeforeTimetableEntries_ForPaidExternal()
        {
            // arrange
            DateTime dateEventOccurs = new DateTime(2020, 6, 6, 0, 0, 0, DateTimeKind.Utc);
            Mock<IPaymentTimetableRepository> paymentTimetableRepositoryMock = new Mock<IPaymentTimetableRepository>();
            paymentTimetableRepositoryMock.Setup(r => r.GetFundingStreamPeriodCensusPeriodInfos(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<CensusPeriodInfo>
                {
                    new CensusPeriodInfo(dateEventOccurs.AddMonths(3), 8, 2020),
                    new CensusPeriodInfo(dateEventOccurs.AddMonths(4), 9, 2020),
                });
            Mock<IDateService> dateServiceMock = new Mock<IDateService>();
            dateServiceMock.Setup(s => s.GetCurrentDate()).Returns(dateEventOccurs);

            Mock<IPolicyFundingStreamPeriodRepository> fspRepository = new Mock<IPolicyFundingStreamPeriodRepository>();
            fspRepository
                .Setup(r => r.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(PaymentMethod.NoPay);

            CensusDateService censusDateService = new CensusDateService(paymentTimetableRepositoryMock.Object, dateServiceMock.Object, fspRepository.Object);

            // act
            var censusPeriodInfo = censusDateService.GetCensusPeriodInfo("some fsp", ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(2020, censusPeriodInfo.Year, "The year is not right");
            Assert.AreEqual(7, censusPeriodInfo.CalendarPeriod, "The CalendarPeriod is not right");
        }
    }
}
