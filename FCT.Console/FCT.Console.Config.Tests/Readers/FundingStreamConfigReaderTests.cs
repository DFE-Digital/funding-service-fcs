namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingStreamConfigReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamConfigReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Stream");
            FundingStreamSheetReader fundingStreamConfigReader = new FundingStreamSheetReader();

            string agencyCode = GetAgencyCode(_reader);

            // act
            var fundingStreamModels = fundingStreamConfigReader.ReadConfig(worksheetReader, agencyCode);
            
            // assert
            Assert.AreEqual(101, fundingStreamModels.Count(), "Incorrect number of funding stream rows read");
            Assert.AreEqual(fundingStreamModels.First().AgencyCode, agencyCode, "Incorrect AgencyCode read on the first row");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamConfigReader_ShouldReturnNullFinanceShortCodeWhenNullInWorkbook()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Stream");
            FundingStreamSheetReader fundingStreamConfigReader = new FundingStreamSheetReader();

            string agencyCode = GetAgencyCode(_reader);

            // act
            IEnumerable<FundingStreamSheetType> fundingStreamModels = fundingStreamConfigReader.ReadConfig(worksheetReader, agencyCode);

            // assert
            Assert.AreEqual(fundingStreamModels.First().AgencyCode, agencyCode, "Incorrect AgencyCode read on the first row");

            var fundingStreamCodeWithNullFinanceShortCode = "16-18NLAP-AS";
            
            FundingStreamSheetType row = fundingStreamModels.SingleOrDefault(fsm => fsm.Code == fundingStreamCodeWithNullFinanceShortCode);

            Assert.IsNotNull(row, $"The {fundingStreamCodeWithNullFinanceShortCode} funding stream row was not read correctly");
            Assert.AreEqual("", row.FinanceShortCode, 
                $"The '{fundingStreamCodeWithNullFinanceShortCode}' funding stream row did not return FinanceShortCode value as an empty string");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamConfigReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Stream");
            FundingStreamSheetReader fundingStreamConfigReader = new FundingStreamSheetReader();

            string agencyCode = GetJsonAgencyCode(_jsonReader);

            // act
            var fundingStreamModels = fundingStreamConfigReader.ReadConfig(worksheetReader, agencyCode);

            // assert
            Assert.AreEqual(101, fundingStreamModels.Count(), "Incorrect number of funding stream rows read");
            Assert.AreEqual(fundingStreamModels.First().AgencyCode, agencyCode, "Incorrect AgencyCode read on the first row");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamConfigReader_Json_ShouldReturnNullFinanceShortCodeWhenNullInWorkbook()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Stream");
            FundingStreamSheetReader fundingStreamConfigReader = new FundingStreamSheetReader();

            string agencyCode = GetJsonAgencyCode(_jsonReader);

            // act
            IEnumerable<FundingStreamSheetType> fundingStreamModels = fundingStreamConfigReader.ReadConfig(worksheetReader, agencyCode);

            // assert
            Assert.AreEqual(fundingStreamModels.First().AgencyCode, agencyCode, "Incorrect AgencyCode read on the first row");

            var fundingStreamCodeWithNullFinanceShortCode = "16-18NLAP-AS";

            FundingStreamSheetType row = fundingStreamModels.SingleOrDefault(fsm => fsm.Code == fundingStreamCodeWithNullFinanceShortCode);

            Assert.IsNotNull(row, $"The {fundingStreamCodeWithNullFinanceShortCode} funding stream row was not read correctly");
            Assert.AreEqual("", row.FinanceShortCode,
                $"The '{fundingStreamCodeWithNullFinanceShortCode}' funding stream row did not return FinanceShortCode value as an empty string");
        }

        private static string GetAgencyCode(WorkbookReader _reader)
        {
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Agency");
            AgencyReader agencySheetReader = new AgencyReader();

            IReadOnlyCollection<AgencySheetType> agencySheetRecords = agencySheetReader.ReadConfig(worksheetReader);

            return agencySheetRecords.First().AgencyShortCode;
        }

        private static string GetJsonAgencyCode(JsonWorkbookReader _jsonReader)
        {
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Agency");
            AgencyReader agencySheetReader = new AgencyReader();

            IReadOnlyCollection<AgencySheetType> agencySheetRecords = agencySheetReader.ReadConfig(worksheetReader);

            return agencySheetRecords.First().AgencyShortCode;
        }
    }
}
