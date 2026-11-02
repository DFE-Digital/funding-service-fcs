namespace FCT.Console.Config.Tests.PaaS.Repositories
{
    using System;
    using Dapper;
    using FCT.Console.Config.Synchronizers.PaaS.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using System.Linq;

    [TestClass]
    public class PaymentTimetableRepositoryTests
    {
        [TestCleanup]
        public void CleanUp()
        {
            ClearPaymentTimetable();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetableRepository_RemoveUnprocessedRows_ShouldRemoveSomeRows()
        {
            // arrange
            const string fspCode = "AEB-CL1819";
            const string doNotRunStatus = "DoNotRun";
            const string completedStatus = "Completed";

            ClearPaymentTimetable();
            CreatePaymentTimetableRow(fspCode, calendarPeriod: "212004", censusEndDate: new DateTime(2021, 4, 6, 22, 00, 00), completedStatus);
            CreatePaymentTimetableRow(fspCode, calendarPeriod: "212005", censusEndDate: new DateTime(2021, 6, 5, 22, 00, 00), doNotRunStatus);
            
            using (var context = new PaymentGenerationDbContext())
            {
                // act
                PaymentTimetableRepository.RemoveUnprocessedRows(context);

                var totalNumberOfRows = context.PaymentTimetables.Count();
                var totalNumberOfRowsNotHavingCompletedStatus = context.PaymentTimetables.Count(pt => pt.Status != completedStatus);

                // assert
                Assert.AreEqual(1, totalNumberOfRows, "Incorrect number of rows remaining in PaymentGeneration.PaymentTimetable table");
                Assert.AreEqual(0, totalNumberOfRowsNotHavingCompletedStatus,  $"Expected number of rows were not removed from PaymentGeneration.PaymentTimetable table");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetableRepository_RemoveUnprocessedRows_ShouldRemoveAllRows()
        {
            // arrange
            const string fspCode = "AEB-CL1819";
            const string doNotRunStatus = "DoNotRun";
            const string completedStatus = "Completed";

            ClearPaymentTimetable();
            CreatePaymentTimetableRow(fspCode, calendarPeriod: "212004", censusEndDate: new DateTime(2021, 4, 6, 22, 00, 00), doNotRunStatus);
            CreatePaymentTimetableRow(fspCode, calendarPeriod: "212005", censusEndDate: new DateTime(2021, 6, 5, 22, 00, 00), doNotRunStatus);

            using (var context = new PaymentGenerationDbContext())
            {
                // act
                PaymentTimetableRepository.RemoveUnprocessedRows(context);

                var totalNumberOfRows = context.PaymentTimetables.Count();
                var totalNumberOfRowsNotHavingCompletedStatus = context.PaymentTimetables.Count(pt => pt.Status != completedStatus);

                // assert
                Assert.AreEqual(0, totalNumberOfRows, "Incorrect number of rows remaining in PaymentGeneration.PaymentTimetable table");
                Assert.AreEqual(0, totalNumberOfRowsNotHavingCompletedStatus, $"Expected number of rows were not removed from PaymentGeneration.PaymentTimetable table");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetableRepository_RemoveUnprocessedRows_ShouldNotRemoveRows()
        {
            // arrange
            const string fspCode = "AEB-CL1819";
            const string completedStatus = "Completed";

            ClearPaymentTimetable();
            CreatePaymentTimetableRow(fspCode, calendarPeriod: "212004", censusEndDate: new DateTime(2021, 4, 6, 22, 00, 00), completedStatus);
            CreatePaymentTimetableRow(fspCode, calendarPeriod: "212005", censusEndDate: new DateTime(2021, 6, 5, 22, 00, 00), completedStatus);

            using (var context = new PaymentGenerationDbContext())
            {
                // act
                PaymentTimetableRepository.RemoveUnprocessedRows(context);

                var totalNumberOfRows = context.PaymentTimetables.Count();
                var totalNumberOfRowsNotHavingCompletedStatus = context.PaymentTimetables.Count(pt => pt.Status != completedStatus);

                // assert
                Assert.AreEqual(totalNumberOfRows, 2, "Incorrect number of rows remaining in PaymentGeneration.PaymentTimetable table");
                Assert.AreEqual(totalNumberOfRowsNotHavingCompletedStatus, 0, $"Incorrect number of rows not having status '{completedStatus}' in PaymentGeneration.PaymentTimetable table");
            }
        }

        private static void CreatePaymentTimetableRow(string fundingStreamPeriodCode, string calendarPeriod, DateTime censusEndDate, string status)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                const string sql = @"INSERT INTO [PaymentGeneration].[PaymentTimetable] 
                                                 ([FundingStreamPeriodCode], [CalendarPeriod], [CalendarPeriodType], [CensusEndDate], [FinancialPeriod], [FinancialPeriodType], 
                                                  [PeriodStartDate], [PeriodEndDate], [PaymentDueDate], [LinkCodeSuffix], [Status])
                                          VALUES (@FundingStreamPeriodCode, @calendarPeriod, 'CM', @CensusEndDate, '201910','FP', 
                                                  '2020-01-01','2020-01-31','2020-01-21','R', @status)";

                context.Database.Connection.Execute(sql, new { fundingStreamPeriodCode, calendarPeriod, censusEndDate, status });
            }
        }

        private static void ClearPaymentTimetable()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                const string sql = "DELETE FROM [PaymentGeneration].[PaymentTimetable]";
                context.Database.Connection.Execute(sql);
            }
        }
    }
}