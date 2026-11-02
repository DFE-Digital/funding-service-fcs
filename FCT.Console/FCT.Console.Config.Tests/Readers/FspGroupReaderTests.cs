namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FspGroupReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupReader_ShouldReadRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Groups");
            FspGroupReader fspGroupReader = new FspGroupReader();

            // act
            IEnumerable<FspGroupSheetType> fspGroupSheetTypes = fspGroupReader.ReadConfig(worksheetReader).ToList();

            // assert
            Assert.AreEqual(80, fspGroupSheetTypes.Count(), "The number of rows is incorrect");
            var fspGroupSheetTypeLoans = fspGroupSheetTypes.SingleOrDefault(s => s.FSPGroupCode == "LOANS1920");
            Assert.IsNotNull(fspGroupSheetTypeLoans, "Not found LOANS1920");
            Assert.AreEqual("Advanced Learner Loans", fspGroupSheetTypeLoans.ContractDocumentDisplayName, "ContractDocumentDisplayName is not correct");
            Assert.AreEqual(1, fspGroupSheetTypeLoans.DisplayOrder, "DisplayOrder is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupReader_Json_ShouldReadRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Groups");
            FspGroupReader fspGroupReader = new FspGroupReader();

            // act
            IEnumerable<FspGroupSheetType> fspGroupSheetTypes = fspGroupReader.ReadConfig(worksheetReader).ToList();

            // assert
            Assert.AreEqual(80, fspGroupSheetTypes.Count(), "The number of rows is incorrect");
            var fspGroupSheetTypeLoans = fspGroupSheetTypes.SingleOrDefault(s => s.FSPGroupCode == "LOANS1920");
            Assert.IsNotNull(fspGroupSheetTypeLoans, "Not found LOANS1920");
            Assert.AreEqual("Advanced Learner Loans", fspGroupSheetTypeLoans.ContractDocumentDisplayName, "ContractDocumentDisplayName is not correct");
            Assert.AreEqual(1, fspGroupSheetTypeLoans.DisplayOrder, "DisplayOrder is not correct");
        }
    }
}
