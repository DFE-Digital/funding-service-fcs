namespace FCT.Console.Config.Tests.Readers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class PaymentTimetablesSheetReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetablesSheetReader_ShouldReadInDateColumnsCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Payment Timetables");
            PaymentTimetablesSheetReader reader = new PaymentTimetablesSheetReader();

            // act
            IEnumerable<PaymentTimetablesSheetType> paymentTimetablesSheetTypes = reader.ReadConfig(worksheetReader);

            // assert
            PaymentTimetablesSheetType sheetType = paymentTimetablesSheetTypes.Single(
                pt => pt.FundingStreamPeriodCode == "AEB-19TRN1920" && pt.CalendarPeriod == "202010");
            Assert.AreEqual(sheetType.PeriodStartDate, new DateTime(2020,10,1,0,0,0,DateTimeKind.Utc));
            Assert.AreEqual(sheetType.PeriodEndDate, new DateTime(2020, 10, 31, 0, 0, 0, DateTimeKind.Utc));
            Assert.AreEqual(sheetType.CensusEndDate, new DateTime(2020, 11, 9, 22, 0, 0, DateTimeKind.Utc));
            Assert.AreEqual(sheetType.LinkCodeSuffix, "R");
            Assert.AreEqual(3, sheetType.PayCalcPolicyVersion);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentTimetablesSheetReader_Json_ShouldReadInDateColumnsCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Payment Timetables");
            PaymentTimetablesSheetReader reader = new PaymentTimetablesSheetReader();

            // act
            IEnumerable<PaymentTimetablesSheetType> paymentTimetablesSheetTypes = reader.ReadConfig(worksheetReader);

            // assert
            PaymentTimetablesSheetType sheetType = paymentTimetablesSheetTypes.Single(
                pt => pt.FundingStreamPeriodCode == "AEB-19TRN1920" && pt.CalendarPeriod == "202010");
            Assert.AreEqual(sheetType.PeriodStartDate, new DateTime(2020, 10, 1, 0, 0, 0, DateTimeKind.Utc));
            Assert.AreEqual(sheetType.PeriodEndDate, new DateTime(2020, 10, 31, 0, 0, 0, DateTimeKind.Utc));
            Assert.AreEqual(sheetType.CensusEndDate, new DateTime(2020, 11, 9, 22, 0, 0, DateTimeKind.Utc));
            Assert.AreEqual(sheetType.LinkCodeSuffix, "R");
            Assert.AreEqual(3, sheetType.PayCalcPolicyVersion);
        }
    }
}
