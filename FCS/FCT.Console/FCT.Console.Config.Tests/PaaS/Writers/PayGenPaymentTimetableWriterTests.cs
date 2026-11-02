namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity.Validation;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PayGenPaymentTimetableWriterTests : TestBase
    {
        private const string FundingStreamPeriodCodeToInsert = "FspCodeToInsert";
        private const string FundingStreamCodeToInsert = "AGE_TEST";
        private const string FundingStreamPeriodCodeDontGeneratePayments = "FspCodeDontGenPymts";

        private const string CalendarPeriodAug = "201508";
        private const string CalendarPeriodSep = "201509";

        [TestInitialize]
        public void Setup()
        {
            CleanUp();
            try
            {
                using (var context = new PaymentGenerationDbContext())
                {
                    context.FundingStreams.Add(new FundingStream
                    {
                        Code = FundingStreamCodeToInsert,
                        AgencyCode = "AC",
                        FinanceShortCode = "FSC",
                        Name = "N"
                    });

                    context.FundingStreamPeriods.Add(new FundingStreamPeriod
                    {
                        Code = FundingStreamPeriodCodeToInsert,
                        FundingStreamCode = FundingStreamCodeToInsert,
                        EndDate = DateTime.Today,
                        Name = "N",
                        StartDate = DateTime.Today
                    });

                    context.FundingStreamPeriods.Add(new FundingStreamPeriod
                    {
                        Code = FundingStreamPeriodCodeDontGeneratePayments,
                        FundingStreamCode = FundingStreamCodeToInsert,                        
                        EndDate = DateTime.Today,
                        Name = "N",
                        StartDate = DateTime.Today
                    });

                    context.SaveChanges();
                }
            }
            catch (DbEntityValidationException ex)
            {
                // Retrieve the error messages as a list of strings.
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                // Join the list to a single string.
                var fullErrorMessage = String.Join("; ", errorMessages);

                // Combine the original exception message with the new one.
                var exceptionMessage = String.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                // Throw a new DbEntityValidationException with the improved exception message.
                throw new DbEntityValidationException(exceptionMessage, ex.EntityValidationErrors);
            }
        }

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                var paymentTimetablesToRemove = new List<PaymentTimetable>();

                var firstTestPaymentTimetable = context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert,
                    CalendarPeriodAug);
                if (firstTestPaymentTimetable != null)
                {
                    paymentTimetablesToRemove.Add(firstTestPaymentTimetable);
                }
               
                paymentTimetablesToRemove.AddRange(context.PaymentTimetables.Where(pt => pt.FundingStreamPeriodCode == FundingStreamPeriodCodeDontGeneratePayments));

                var paymentTimeTableSep = context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert,
                    CalendarPeriodSep);

                if (paymentTimeTableSep != null)
                {
                    paymentTimetablesToRemove.Add(paymentTimeTableSep);
                }

                paymentTimetablesToRemove.ForEach(pt => context.PaymentTimetables.Remove(pt));

                context.FundingStreamPeriods.Where(fsp => fsp.Code == FundingStreamPeriodCodeToInsert || fsp.Code == FundingStreamPeriodCodeDontGeneratePayments)
                     .ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.FundingStreams.Where(fs => fs.Code == FundingStreamCodeToInsert).ForEach(fs => context.FundingStreams.Remove(fs));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewPaymentTimetable_NewPaymentTimetable_IsInserted_InPaasTable()
        {
            //arrange
            List<PaymentTimetablesSheetType> testPaymentTimetables = CreateApprovedTestPaymentTimetables();
            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreamPeriods.Find(FundingStreamPeriodCodeToInsert).ShouldGeneratePayments = true;

                context.SaveChanges();
            }

            // act
            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(testPaymentTimetables, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                Assert.IsNotNull(context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert, CalendarPeriodAug));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anPaymentTimetable_ExistingPaymentTimetable_IsUpdated_InPaasTable()
        {
            // arrange
            var updatedValue = DateTime.Now.AddDays(1);

            //Setup data
            using (var context = new PaymentGenerationDbContext())
            {
                var originalTestPaymentTimetables = CreateApprovedTestPaymentTimetables();
                context.PaymentTimetables.AddRange(PaymentTimetableTransformer.TransformToPaymentTimetableCollection(originalTestPaymentTimetables));
                context.FundingStreamPeriods.Find(FundingStreamPeriodCodeToInsert).ShouldGeneratePayments = true;
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestPaymentTimetables = CreateApprovedTestPaymentTimetables();
            newTestPaymentTimetables[0].PeriodStartDate = updatedValue;

            // act
            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(newTestPaymentTimetables, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var updatedRecord = context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert, CalendarPeriodAug);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedValue.Date, updatedRecord.PeriodStartDate.Date);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anPaymentTimetable_ExistingPaymentTimetable_IsUpdatedWhenCalendarPeriodPartKeyHasChanged_InPaasTable()
        {
            // arrange
            var updatedValue = DateTime.Now.AddDays(1);

            //Setup data
            using (var context = new PaymentGenerationDbContext())
            {
                var originalTestPaymentTimetables = CreateApprovedTestPaymentTimetables();
                context.PaymentTimetables.AddRange(PaymentTimetableTransformer.TransformToPaymentTimetableCollection(originalTestPaymentTimetables));
                context.FundingStreamPeriods.Find(FundingStreamPeriodCodeToInsert).ShouldGeneratePayments = true;
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestPaymentTimetables = CreateApprovedTestPaymentTimetables();
            newTestPaymentTimetables[0].CalendarPeriod = CalendarPeriodSep;
            newTestPaymentTimetables[0].PeriodStartDate = updatedValue;

            // act
            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(newTestPaymentTimetables, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var updatedRecord = context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert, CalendarPeriodSep);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedValue.Date, updatedRecord.PeriodStartDate.Date);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aPaymentTimetableToBeDeleted_ThePaymentTimetable_IsDeleted_InPaasTable()
        {
            // arrange
            var testPaymentTimetables = CreateTestPaymentTimetablesToDelete();

            //Setup data to delete
            using (var context = new PaymentGenerationDbContext())
            {
                context.PaymentTimetables.AddRange(PaymentTimetableTransformer.TransformToPaymentTimetableCollection(testPaymentTimetables));
                context.SaveChanges();
            }

            // act
            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(testPaymentTimetables, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var deletedRecord = context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert, CalendarPeriodAug);
                Assert.IsNull(deletedRecord);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayGenPaymentTimetableWriter_ShouldOnlyUpdateRowsThatHaveAStatusOfNotStarted()
        {
            // arrange
            var initialPaymentTimeTables = CreateCompletedAndNotStartedPaymentTimetables();

            //Setup data to delete
            using (var context = new PaymentGenerationDbContext())
            {
                context.PaymentTimetables.AddRange(PaymentTimetableTransformer.TransformToPaymentTimetableCollection(initialPaymentTimeTables));
                context.FundingStreamPeriods.Find(FundingStreamPeriodCodeToInsert).ShouldGeneratePayments = true;
                context.SaveChanges();
            }

            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(initialPaymentTimeTables, WriterBehaviour.AddOrUpdate);

            // now modify the objects 
            DateTime newPeriodStartDate = new DateTime(2016, 8, 02).Date;
            var paymentTimeTables = CreateCompletedAndNotStartedPaymentTimetables();
            paymentTimeTables.Single(pt => pt.Status == "NotStarted").PeriodStartDate = newPeriodStartDate;
            paymentTimeTables.Single(pt => pt.Status == "Completed").PeriodStartDate = newPeriodStartDate;

            // act
            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(paymentTimeTables, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var paymentTimeTableAug =  context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert, CalendarPeriodAug);
                var paymentTimeTableSep = context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert, CalendarPeriodSep);
                Assert.AreEqual(paymentTimeTableAug.PeriodStartDate, newPeriodStartDate);
                Assert.AreNotEqual(paymentTimeTableSep.PeriodStartDate, newPeriodStartDate, "We have incorrectly updated a completed row");

            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayGenPaymentTimetableWriter_ShouldNotWriteFundingStreamPeriodsToThePaymentTimetableWhen_GeneratePaymentsIsFalse()
        {
            // arrange
            var paymentTimeTablesIncludingAnExternallyPaidOne = CreateOneGeneratePaymentsAndOneNotGeneratePaymentsPaymentTimetables();
            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreamPeriods.Find(FundingStreamPeriodCodeToInsert).ShouldGeneratePayments = true;
                context.FundingStreamPeriods.Find(FundingStreamPeriodCodeDontGeneratePayments).ShouldGeneratePayments = false;

                context.SaveChanges();
            }

            // act
                PayGenPaymentTimetableWriter.WriteToPaaSDatabase(paymentTimeTablesIncludingAnExternallyPaidOne, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var paymentTimeTableAug = context.PaymentTimetables.Find(FundingStreamPeriodCodeToInsert, CalendarPeriodAug);
                var paymentTimeTableExternallyPaid =
                    context.PaymentTimetables.Find(FundingStreamPeriodCodeDontGeneratePayments, CalendarPeriodAug);
                Assert.IsNotNull(paymentTimeTableAug, "The non externally Paid Payment Timetable has not been inserted");
                Assert.IsNull(paymentTimeTableExternallyPaid, "The externally paid Payment Timetable has been added incorrectly");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PayGenPaymentTimetableWriter_ShouldDeleteExistingRecordsFromPaasWhenGeneratePaymentsIsNowFalse()
        {
            // arrange
            var paymentTimeTablesIncludingRemovedRowWhereGeneratePaymentsIsFalse = CreateRemovedDontGeneratePaymentsPaymentTimetable();

            using (var context = new PaymentGenerationDbContext())
            {
                context.PaymentTimetables.AddRange(PaymentTimetableTransformer.TransformToPaymentTimetableCollection(paymentTimeTablesIncludingRemovedRowWhereGeneratePaymentsIsFalse));
                context.SaveChanges();
            }

            // act
            PayGenPaymentTimetableWriter.WriteToPaaSDatabase(paymentTimeTablesIncludingRemovedRowWhereGeneratePaymentsIsFalse, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var paymentTimeTableRemovedWhereGeneratePaymentsIsFalse =
                    context.PaymentTimetables.Find(FundingStreamPeriodCodeDontGeneratePayments, CalendarPeriodAug);
                Assert.IsNull(paymentTimeTableRemovedWhereGeneratePaymentsIsFalse, "The externally paid Payment Timetable has not been deleted");
            }
        }

        private static IReadOnlyCollection<PaymentTimetablesSheetType> CreateRemovedDontGeneratePaymentsPaymentTimetable()
        {
            return new List<PaymentTimetablesSheetType>
            {
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = FundingStreamPeriodCodeDontGeneratePayments,
                    CalendarPeriod = CalendarPeriodAug,
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2016, 4, 2),
                    FinancialPeriod = "201601",
                    FinancialPeriodType = "FP",
                    DueDate = new DateTime(2016, 4, 2),
                    PeriodStartDate = DateTime.Now,
                    PeriodEndDate = DateTime.Now.AddDays(30),
                    PolicyStatus = PolicyStatus.Removed,
                    LinkCodeSuffix = "A",
                    Status = "NotStarted",
                }
            };
        }

        private List<PaymentTimetablesSheetType> CreateTestPaymentTimetablesToDelete()
        {
            return new List<PaymentTimetablesSheetType>
            {
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = FundingStreamPeriodCodeToInsert,
                    CalendarPeriod = CalendarPeriodAug,
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2016, 4, 1),
                    FinancialPeriod = "201601",
                    FinancialPeriodType = "FP",
                    DueDate = new DateTime(2016, 4, 2),
                    PeriodStartDate = DateTime.Now,
                    PeriodEndDate = DateTime.Now.AddDays(30),
                    PolicyStatus = PolicyStatus.Removed,
                    LinkCodeSuffix = "A",
                    Status = "NotStarted"
                }
            };
        }

        private IReadOnlyCollection<PaymentTimetablesSheetType> CreateCompletedAndNotStartedPaymentTimetables()
        {
            return new List<PaymentTimetablesSheetType>
            {
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = FundingStreamPeriodCodeToInsert,
                    CalendarPeriod = CalendarPeriodAug,
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2016, 4, 2),
                    FinancialPeriod = "201601",
                    FinancialPeriodType = "FP",
                    DueDate = new DateTime(2016, 4, 2),
                    PeriodStartDate = DateTime.Now,
                    PeriodEndDate = DateTime.Now.AddDays(30),
                    PolicyStatus = PolicyStatus.Approved,
                    LinkCodeSuffix = "A",
                    Status = "NotStarted"
                },
                CreateCompletedPaymentTimetablesSheetType()
            };
        }

        private IReadOnlyCollection<PaymentTimetablesSheetType> CreateOneGeneratePaymentsAndOneNotGeneratePaymentsPaymentTimetables()
        {
            return new List<PaymentTimetablesSheetType>
            {
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = FundingStreamPeriodCodeToInsert,
                    CalendarPeriod = CalendarPeriodAug,
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2016, 4, 2),
                    FinancialPeriod = "201601",
                    FinancialPeriodType = "FP",
                    DueDate = new DateTime(2016, 4, 2),
                    PeriodStartDate = DateTime.Now,
                    PeriodEndDate = DateTime.Now.AddDays(30),
                    PolicyStatus = PolicyStatus.Approved,
                    LinkCodeSuffix = "A",
                    Status = "NotStarted"
                },
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = FundingStreamPeriodCodeDontGeneratePayments,
                    CalendarPeriod = CalendarPeriodAug,
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2016, 4, 2),
                    FinancialPeriod = "201601",
                    FinancialPeriodType = "FP",
                    DueDate = new DateTime(2016, 4, 2),
                    PeriodStartDate = DateTime.Now,
                    PeriodEndDate = DateTime.Now.AddDays(30),
                    PolicyStatus = PolicyStatus.Approved,
                    LinkCodeSuffix = "A",
                    Status = "NotStarted",
                }
            };
        }

        private PaymentTimetablesSheetType CreateCompletedPaymentTimetablesSheetType()
        {
            return new PaymentTimetablesSheetType
            {
                FundingStreamPeriodCode = FundingStreamPeriodCodeToInsert,
                CalendarPeriod = CalendarPeriodSep,
                CalendarPeriodType = "CM",
                CensusEndDate = new DateTime(2016, 4, 1),
                FinancialPeriod = "201601",
                FinancialPeriodType = "FP",
                DueDate = new DateTime(2016, 4, 2),
                PeriodStartDate = DateTime.Now,
                PeriodEndDate = DateTime.Now.AddDays(30),
                PolicyStatus = PolicyStatus.Approved,
                LinkCodeSuffix = "A",
                Status = "Completed"
            };
        }

        private static List<PaymentTimetablesSheetType> CreateApprovedTestPaymentTimetables()
        {
            return new List<PaymentTimetablesSheetType>
            {
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = FundingStreamPeriodCodeToInsert,
                    CalendarPeriod = CalendarPeriodAug,
                    CalendarPeriodType = "CM",
                    CensusEndDate = new DateTime(2016, 4, 1),
                    FinancialPeriod = "201601",
                    FinancialPeriodType = "FP",
                    DueDate = new DateTime(2016, 4, 2),
                    PeriodStartDate = DateTime.Now,
                    PeriodEndDate = DateTime.Now.AddDays(30),
                    PolicyStatus = PolicyStatus.Approved,
                    LinkCodeSuffix = "A",
                    Status = "NotStarted"
                }
            };
        }
    }
}
