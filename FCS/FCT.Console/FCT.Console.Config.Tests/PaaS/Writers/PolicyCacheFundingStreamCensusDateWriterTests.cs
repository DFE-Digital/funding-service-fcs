namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using Config.Transformers;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using UnitTests.Common;

    [TestClass]
    public class PolicyCacheFundingStreamCensusDateWriterTests : TestBase
    {
        private const string FundingStreamPeriodCodeToInsert = "FspCodeToInsert";
        private readonly DateTime _censusDateToInsert = new DateTime(2016, 4, 1);

        [TestCleanup, TestInitialize]
        public void CleanUp()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                TestTidyUpHelper.RemoveByKey(context.PolicyFundingStreamCensusDates, FundingStreamPeriodCodeToInsert, _censusDateToInsert.Year, _censusDateToInsert.Month);
                TestTidyUpHelper.RemoveByKey(context.PolicyFundingStreamPeriods, FundingStreamPeriodCodeToInsert);
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewPolicyFundingStreamCensusDate_PolicyFundingStreamCensusDate_IsInserted_InPaasTable()
        {
            //arrange
            List<PaymentTimetablesSheetType> testFundingStreamCensusDates = CreateApprovedTestFundingStreamCensusDates();

            // act
            PolicyCacheFundingStreamCensusDateWriter.WriteToPaaSDatabase(testFundingStreamCensusDates, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                Assert.IsNotNull(context.PolicyFundingStreamCensusDates.Find(FundingStreamPeriodCodeToInsert, _censusDateToInsert.Year, _censusDateToInsert.Month));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedPolicyFundingStreamCensusDate_ExistingPolicyFundingStreamCensusDate_IsUpdated_InPaasTable()
        {
            // arrange
            DateTime updatedDate = DateTime.Now;


            //Setup data
            using (var context = new PaymentManagementPolicyContext())
            {
                var originalTestFundingStreamCensusDates = CreateApprovedTestFundingStreamCensusDates();
                var transformedFundingStreamCensusDates = PaymentTimetableTransformer.TransformCollectionToPolicyFundingStreamCensusDates(
                    originalTestFundingStreamCensusDates);

                transformedFundingStreamCensusDates.ToList().ForEach(x =>
                {
                    context.PolicyFundingStreamCensusDates.Add(x);
                });

                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestFundingStreamCensusDates = CreateApprovedTestFundingStreamCensusDates();
            newTestFundingStreamCensusDates[0].CensusEndDate = updatedDate;

            // act
            PolicyCacheFundingStreamCensusDateWriter.WriteToPaaSDatabase(newTestFundingStreamCensusDates, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                var updatedRecord = context.PolicyFundingStreamCensusDates.Find(FundingStreamPeriodCodeToInsert, _censusDateToInsert.Year, _censusDateToInsert.Month);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedDate.ToString(CultureInfo.InvariantCulture), updatedRecord.CensusDate.ToString(CultureInfo.InvariantCulture));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aFundingStreamToBeDeleted_TheFundingStream_IsDeleted_InPaasTable()
        {
            // arrange
            var testFundingStreamCensusDates = CreateTestFundingStreamCensusDatesToDelete();

            //Setup data to delete
            using (var context = new PaymentManagementPolicyContext())
            {
                var transformedFundingStreamCensusDates = PaymentTimetableTransformer.TransformCollectionToPolicyFundingStreamCensusDates(testFundingStreamCensusDates);

                transformedFundingStreamCensusDates.ToList().ForEach(x =>
                {
                    context.PolicyFundingStreamCensusDates.Add(x);
                });

                context.SaveChanges();
            }

            // act
            PolicyCacheFundingStreamCensusDateWriter.WriteToPaaSDatabase(testFundingStreamCensusDates, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                var deletedRecord = context.PolicyFundingStreamCensusDates.Find(FundingStreamPeriodCodeToInsert, _censusDateToInsert.Year, _censusDateToInsert.Month);
                Assert.IsNull(deletedRecord);
            }
        }

        private List<PaymentTimetablesSheetType> CreateTestFundingStreamCensusDatesToDelete()
        {
            return new List<PaymentTimetablesSheetType>
            {
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = FundingStreamPeriodCodeToInsert,
                    CensusEndDate = _censusDateToInsert,
                    CalendarPeriod = "201604",
                    PolicyStatus = PolicyStatus.Removed
                }
            };
        }

        private List<PaymentTimetablesSheetType> CreateApprovedTestFundingStreamCensusDates()
        {
            // arrange
            return new List<PaymentTimetablesSheetType>
            {
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = FundingStreamPeriodCodeToInsert,
                    CensusEndDate = _censusDateToInsert,
                    CalendarPeriod = "201604",
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
