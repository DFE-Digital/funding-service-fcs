namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;

    [TestClass]
    public class FundingTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type");
            FundingTypeReader fundingTypeReader = new FundingTypeReader();

            // act
            IReadOnlyCollection<FundingTypeSheetType> fundingTypeItems = fundingTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(38, fundingTypeItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeReader_ShouldReadArbitraryFundingTypeRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Type");
            FundingTypeReader fundingTypeReader = new FundingTypeReader();

            // act
            IReadOnlyCollection<FundingTypeSheetType> fundingTypeItems = fundingTypeReader.ReadConfig(worksheetReader);

            // assert
            FundingTypeSheetType rowInSheet = fundingTypeItems.Skip(4).FirstOrDefault();
            Assert.IsNotNull(rowInSheet, "The third row was not read correctly");
            Assert.AreEqual("Adult Education Budget", rowInSheet.FundingTypeName, "the funding type name was not correctly read");
            Assert.AreEqual("AEB", rowInSheet.FundingTypeCode, "the funding type code was not correctly read");
            Assert.AreEqual(1, rowInSheet.AgencyCode, "the agency code was not correctly read");
            Assert.AreEqual("AEBP", rowInSheet.ContractReferencePrefix, "the contractreferenceprefix was not correctly read");
            Assert.AreEqual(false, rowInSheet.AllowMultipleContracts, "the allow mulitple contracts was not correctly read");
            Assert.AreEqual(true, rowInSheet.DocumentationRequired, "the documentation required was not correctly read");

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();

            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type");
            FundingTypeReader fundingTypeReader = new FundingTypeReader();

            // act
            IReadOnlyCollection<FundingTypeSheetType> fundingTypeItems = fundingTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(38, fundingTypeItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeReader_Json_ShouldReadArbitraryFundingTypeRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();

            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type");
            FundingTypeReader fundingTypeReader = new FundingTypeReader();

            // act
            IReadOnlyCollection<FundingTypeSheetType> fundingTypeItems = fundingTypeReader.ReadConfig(worksheetReader);

            // assert
            FundingTypeSheetType rowInSheet = fundingTypeItems.Skip(4).FirstOrDefault();
            Assert.IsNotNull(rowInSheet, "The third row was not read correctly");
            Assert.AreEqual("Adult Education Budget", rowInSheet.FundingTypeName, "the funding type name was not correctly read");
            Assert.AreEqual("AEB", rowInSheet.FundingTypeCode, "the funding type code was not correctly read");
            Assert.AreEqual(1, rowInSheet.AgencyCode, "the agency code was not correctly read");
            Assert.AreEqual("AEBP", rowInSheet.ContractReferencePrefix, "the contractreferenceprefix was not correctly read");
            Assert.AreEqual(false, rowInSheet.AllowMultipleContracts, "the allow mulitple contracts was not correctly read");
            Assert.AreEqual(true, rowInSheet.DocumentationRequired, "the documentation required was not correctly read");

        }

    }
}
