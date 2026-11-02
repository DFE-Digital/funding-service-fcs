namespace FCT.Console.Config.Tests
{
    using System;
    using System.Linq;
    using Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Excel;

    [TestClass]
    public class WorksheetRowReaderTests : TestBase
    {
        private WorkbookReader _reader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WorksheetRowReader_ShouldReturnCellStringValueWhenGivenACellName()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Agency");

            // act
            int numRows = worksheetReader.GetNumberOfRows();
            string cellValue = worksheetReader.CellStringValue("D2");

            // assert
            Assert.AreEqual(2, numRows, "The number of rows are not correct");
            Assert.AreEqual("Department for Education", cellValue);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WorksheetRowReader_ShouldReturnEnumerableWith2Rows()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Agency");

            // act
            var rows = worksheetReader.Rows();

            // assert
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WorksheetRowReader_ShouldReturnDateTimeWhenDateTimeCellRequested()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Funding Period");

            // act
            DateTime cellDateTime = worksheetReader.CellDateValue("D2");

            // assert
            DateTime startDate = new DateTime(2015,8,1);
            Assert.AreEqual(startDate, cellDateTime);
        }
    }
}
