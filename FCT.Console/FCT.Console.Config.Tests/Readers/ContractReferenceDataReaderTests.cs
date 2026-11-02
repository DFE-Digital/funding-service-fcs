namespace FCT.Console.Config.Tests.Readers
{
    using System.Linq;
    using FCT.Console.Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class ContractReferenceDataReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractReferenceDataReader_ShouldReadAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Contract Ref Data");
            var reader = new ContractReferenceDataReader();

            // act
            var rows = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(248, rows.Count(), "Unexpected number of rows returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractReferenceDataReader_ShouldReadArbitraryRowValues()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Contract Ref Data");
            var reader = new ContractReferenceDataReader();

            // act
            var rows = reader.ReadConfig(worksheetReader);

            // assert
            var row = rows.SingleOrDefault(s => s.Ukprn == 10000028 && s.FundingStreamPeriodCode == "AEB-AS2021");

            Assert.IsNotNull(row, "Contract Ref Data row not found");
            Assert.AreEqual(78335m, row.FinancialEnvelope1Funding, "Contract Ref Data - FinancialEnvelope1Funding incorrect");
            Assert.AreEqual(38496m, row.FinancialEnvelope2Funding, "Contract Ref Data - FinancialEnvelope2Funding incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractReferenceDataReader_Json_ShouldReadAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("Contract Ref Data");
            var reader = new ContractReferenceDataReader();

            // act
            var rows = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(248, rows.Count(), "Unexpected number of rows returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractReferenceDataReader_Json_ShouldReadArbitraryRowValues()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("Contract Ref Data");
            var reader = new ContractReferenceDataReader();

            // act
            var rows = reader.ReadConfig(worksheetReader);

            // assert
            var row = rows.SingleOrDefault(s => s.Ukprn == 10000028 && s.FundingStreamPeriodCode == "AEB-AS2021");

            Assert.IsNotNull(row, "Contract Ref Data row not found");
            Assert.AreEqual(78335m, row.FinancialEnvelope1Funding, "Contract Ref Data - FinancialEnvelope1Funding incorrect");
            Assert.AreEqual(38496m, row.FinancialEnvelope2Funding, "Contract Ref Data - FinancialEnvelope2Funding incorrect");
        }
    }
}