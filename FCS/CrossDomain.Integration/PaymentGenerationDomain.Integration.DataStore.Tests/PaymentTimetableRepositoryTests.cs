namespace PaymentGenerationDomain.Integration.DataStore.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Model;
    using Repositories;
    using UnitTests.Common;
    using MoreLinq;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class PaymentTimetableRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetableRepository_HasOutstandingPaymentTimetablesForFundingStreamPeriod_ShouldReturnTrueWhenFSPExistswithNotStartedRecords()
        {
            // Arrange
            const string fundingStreamPeriodCode = "TEST_FSP_CODE";
            const string fundingStreamCode = "TEST_FS_CODE";

            TearDown(fundingStreamCode);          
            CreatePaymentTimetableRecords(fundingStreamCode, fundingStreamPeriodCode);

            using (PaymentGenerationDbContext context = new PaymentGenerationDbContext())
            {
                IPaymentTimetableRepository paymentTimetableRepository = new PaymentTimetableRepository();
                // Act    
                bool resp = paymentTimetableRepository.HasOutstandingPaymentTimetablesForFundingStreamPeriod(fundingStreamPeriodCode, ConnectionInfo.CreateFrom(context.Database.Connection));

                //Assert
                Assert.IsTrue(resp, "HasOutstandingPaymentTimetablesForFundingStreamPeriod incorrectly returned false");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetableRepository_HasOutstandingPaymentTimetablesForFundingStreamPeriod_ShouldReturnFalseWhenFSPDoesNotExist()
        {
            // Arrange
            const string fundingStreamPeriodCode = "TEST_FSP_CODE";
            const string fundingStreamCode = "TEST_FS_CODE";

            TearDown(fundingStreamCode);

            using (PaymentGenerationDbContext context = new PaymentGenerationDbContext())
            {
                IPaymentTimetableRepository paymentTimetableRepository = new PaymentTimetableRepository();
                // Act    
                bool resp = paymentTimetableRepository.HasOutstandingPaymentTimetablesForFundingStreamPeriod(fundingStreamPeriodCode, ConnectionInfo.CreateFrom(context.Database.Connection));

                //Assert
                Assert.IsFalse(resp, "HasOutstandingPaymentTimetablesForFundingStreamPeriod incorrectly returned true");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetableRepository_HasOutstandingPaymentTimetablesForFundingStreamPeriod_ShouldReturnFalseWhenFSPExistswithNoNotStartedRecords()
        {
            // Arrange
            const string fundingStreamPeriodCode = "TEST_FSP_CODE";
            const string fundingStreamCode = "TEST_FS_CODE";

            TearDown(fundingStreamCode);
            CreatePaymentTimetableRecords(fundingStreamCode, fundingStreamPeriodCode);

            using (PaymentGenerationDbContext context = new PaymentGenerationDbContext())
            {
                context.PaymentTimetables.Where(pt => pt.FundingStreamPeriodCode == fundingStreamPeriodCode).ForEach(p => p.Status = "Completed");
                context.SaveChanges();
            }

            using (PaymentGenerationDbContext context = new PaymentGenerationDbContext())
            {
                IPaymentTimetableRepository paymentTimetableRepository = new PaymentTimetableRepository();
                // Act    
                bool resp = paymentTimetableRepository.HasOutstandingPaymentTimetablesForFundingStreamPeriod(fundingStreamPeriodCode, ConnectionInfo.CreateFrom(context.Database.Connection));

                //Assert
                Assert.IsFalse(resp, "HasOutstandingPaymentTimetablesForFundingStreamPeriod incorrectly returned true");
            }
        }

        private static void TearDown(string fundingStreamCode)
        {
            using (PaymentGenerationDbContext context = new PaymentGenerationDbContext())
            {
                // FK cascade delete will clean up FundingStreamPeriods and PaymentTimetables
                context.FundingStreams.RemoveWhere(fs => fs.Code == fundingStreamCode);
                context.SaveChanges();
            }
        }

        private static void CreatePaymentTimetableRecords(string fundingStreamCode, string fundingStreamPeriodCode)
        {
            FundingStream fundingStream = new FundingStream
            {
                AgencyCode = "AgencyCode",
                Code = fundingStreamCode,
                FinanceShortCode = "FinanceShortCode",
                Name = "Name"
            };

            FundingStreamPeriod fundingStreamPeriod = new FundingStreamPeriod
            {
                Code = fundingStreamPeriodCode,
                Name = "Name",
                FundingStreamCode = fundingStreamPeriodCode,
                FundingStream = fundingStream,
                StartDate = new DateTime(),
                EndDate = new DateTime(),
            };

            using (PaymentGenerationDbContext context = new PaymentGenerationDbContext())
            {
                context.PaymentTimetables.Add(new PaymentTimetable
                {
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    CalendarPeriod = "201805",
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2018, 05, 03, 22, 00, 00, 00),
                    FinancialPeriodType = "FP",
                    Status = "NotStarted",
                    FundingStreamPeriod = fundingStreamPeriod
                });
                context.PaymentTimetables.Add(new PaymentTimetable
                {
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    CalendarPeriod = "201806",
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2018, 06, 05, 22, 00, 00, 00),
                    FinancialPeriodType = "FP",
                    Status = "NotStarted",
                    FundingStreamPeriod = fundingStreamPeriod
                });
                context.PaymentTimetables.Add(new PaymentTimetable
                {
                    FundingStreamPeriodCode = fundingStreamPeriodCode,
                    CalendarPeriod = "201807",
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2018, 07, 04, 22, 00, 00, 00),
                    FinancialPeriodType = "FP",
                    Status = "NotStarted",
                    FundingStreamPeriod = fundingStreamPeriod
                });
                context.SaveChanges();
            }
        }
    }
}
