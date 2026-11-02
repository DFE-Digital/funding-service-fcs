namespace FCT.Console.Config.Tests.Transformers
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Collections.Generic;
    using ExcelTypes;
    using System.Linq;
    using Config.Transformers;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class PaymentTimetableTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentTimetableTransformer_ConvertToPayGenPaymentTimetable()
        {
            // Arrange
            List<PaymentTimetablesSheetType> ptSheetTypes = new List<PaymentTimetablesSheetType>()
            {
                new PaymentTimetablesSheetType()
                {
                    FundingStreamPeriodCode = "ASC1516",
                    CalendarPeriod = "201604",
                    CalendarPeriodType = "CM",
                    FinancialPeriod = "201601",
                    FinancialPeriodType = "FP",
                    PeriodStartDate = new DateTime(2016, 4, 1),
                    PeriodEndDate = new DateTime(2016, 4, 30),
                    CensusEndDate = new DateTime(2016, 5, 19, 22, 00, 00),
                    DueDate = new DateTime(2016, 5, 26),
                    PolicyStatus = PolicyStatus.Approved,
                    LinkCodeSuffix = "A",
                    Status = "NotStarted"
                }
            };

            // Act
            IReadOnlyCollection<PaymentGenerationDomain.Integration.DataStore.Model.PaymentTimetable> pgPaymentTimetables = 
                PaymentTimetableTransformer.TransformToPaymentTimetableCollection(ptSheetTypes).ToList();

            // Assert
            Assert.AreEqual(ptSheetTypes.Count, pgPaymentTimetables.Count);
            var firstRecord = pgPaymentTimetables.First();
            Assert.AreEqual(ptSheetTypes[0].FundingStreamPeriodCode, firstRecord.FundingStreamPeriodCode);
            Assert.AreEqual(ptSheetTypes[0].CalendarPeriod, firstRecord.CalendarPeriod);
            Assert.AreEqual(ptSheetTypes[0].CalendarPeriodType, firstRecord.CalendarPeriodType);
            Assert.AreEqual(ptSheetTypes[0].FinancialPeriod, firstRecord.FinancialPeriod);
            Assert.AreEqual(ptSheetTypes[0].FinancialPeriodType, firstRecord.FinancialPeriodType);
            Assert.AreEqual(ptSheetTypes[0].PeriodStartDate, firstRecord.PeriodStartDate);
            Assert.AreEqual(ptSheetTypes[0].PeriodEndDate, firstRecord.PeriodEndDate);
            Assert.AreEqual(ptSheetTypes[0].CensusEndDate, firstRecord.CensusEndDate);
            Assert.AreEqual(ptSheetTypes[0].DueDate, firstRecord.PaymentDueDate);
            Assert.AreEqual(ptSheetTypes[0].LinkCodeSuffix, firstRecord.LinkCodeSuffix);
            Assert.AreEqual(ptSheetTypes[0].Status, firstRecord.Status);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ConvertPaymentTimetableSheetTypeToPolicyFundingStreamCensusDate_IsSuccessful()
        {
            //Arrange
            var censusDate = DateTime.Now;
            var dueDate = DateTime.Now.AddDays(1);
            var startDate = DateTime.Now.AddDays(2);
            var endDate = DateTime.Now.AddDays(3);

            List<PaymentTimetablesSheetType> fspSheetTypes = new List<PaymentTimetablesSheetType>
            {
                new PaymentTimetablesSheetType
                {
                    FundingStreamPeriodCode = "AGE1516",
                    CalendarPeriod = "201504",
                    CalendarPeriodType = "CM",
                    FinancialPeriod = "201501",
                    FinancialPeriodType = "FP",
                    CensusEndDate = censusDate,
                    DueDate = dueDate,
                    PeriodStartDate = startDate,
                    PeriodEndDate = endDate,
                    PolicyStatus = PolicyStatus.Approved
                }
            };

            // Act
            IReadOnlyCollection<PolicyFundingStreamCensusDate> policyFundingStreamCensusDates = 
                PaymentTimetableTransformer.TransformCollectionToPolicyFundingStreamCensusDates(fspSheetTypes).ToList();

            // Assert
            Assert.AreEqual(fspSheetTypes.Count, policyFundingStreamCensusDates.Count);
            var firstRecord = policyFundingStreamCensusDates.First();
            Assert.AreEqual(fspSheetTypes[0].FundingStreamPeriodCode, firstRecord.FundingStreamPeriod);
            Assert.AreEqual(fspSheetTypes[0].CensusEndDate, firstRecord.CensusDate);
            Assert.AreEqual(int.Parse(fspSheetTypes[0].CalendarPeriod.Substring(0, 4)), firstRecord.CalendarYear);
            Assert.AreEqual(int.Parse(fspSheetTypes[0].CalendarPeriod.Substring(4, 2)), firstRecord.CalendarPeriod);
        }
    }
}
