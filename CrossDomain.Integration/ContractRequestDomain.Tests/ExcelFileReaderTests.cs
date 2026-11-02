using SFA.FCT.ContractRequestDomain.Common;

namespace ContractRequestDomain.Tests
{
    using System;
    using System.IO;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.Events;
    using UnitTests.Common;

    [TestClass]
    public class ExcelFileReaderTests
    {
        private ExcelFileParser _parser;
        private byte[] _excelFile;
        private byte[] _pdfFile;

        [TestInitialize]
        public void GetData()
        {
            _parser = new ExcelFileParser();
            using (
               TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 Demo.xlsx"))
            {
                _excelFile = TestUtils.FileToByteArray(resource.Stream);
            }
            using (
              TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.MAIN AY 1516 11022015150000 PDF.xlsx"))
            {
                _pdfFile = TestUtils.FileToByteArray(resource.Stream);
            }
        }

        [TestMethod, TestCategory("UnitTest")] 
        public void ExcelFileReader_DateReturnsCleanDate()
        {
            var x = new SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload.rowType();

            DateTime? dt = x.GetDateTime("05/09/2015");
 
            Assert.IsTrue(dt.HasValue);
            Assert.IsTrue(dt.Value.ToUniversalTime().Hour == 0);
 
        }
       
        [TestMethod, TestCategory("UnitTest")]
        public void ExcelFileReader_LoadsAnExcelFile()
        {
            dataLoadResults result;

            using (MemoryStream stream = new MemoryStream(_excelFile))
            {
                result = _parser.ReadFile(stream, "TestFileName.xlsx");
            }

            Assert.IsNotNull(result);
            Assert.IsNotNull(result.workbook);
            Assert.AreEqual<int>(5, result.workbook.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExcelFileReader_LoadsAnExcelFileControlSheet()
        {
            ContractBulkUpload result;
            
            using (MemoryStream stream = new MemoryStream(_excelFile))
            {
                result = new ContractBulkUpload(_parser.ReadFile(stream, "TestFileName.xlsx"));
            }

            Assert.IsNotNull(result.ControlSheet);
            Assert.AreEqual<int>(1, result.ControlSheet.row.Length);
            Assert.AreEqual<int>(3, result.ControlSheet.row[0].cell.Length);
            Assert.AreEqual<string>("24+LOANS", result.ControlSheet.row[0].GetCellValue("FundingTypeCode"));
            Assert.AreEqual<string>("AY", result.ControlSheet.row[0].GetCellValue("PeriodTypeCode"));
            Assert.AreEqual<string>("1516", result.ControlSheet.row[0].GetCellValue("Period"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExcelFileReader_LoadsAnExcelFileContractSheet()
        {
           ContractBulkUpload result;
            
            using (MemoryStream stream = new MemoryStream(_excelFile))
            {
                result = new ContractBulkUpload(_parser.ReadFile(stream, "TestFileName.xlsx"));
            }
            Assert.IsNotNull(result.ContractSheet);
            Assert.AreEqual<int>(1, result.ContractSheet.row.Length);
            Assert.AreEqual<int>(9, result.ContractSheet.row[0].cell.Length);
            Assert.AreEqual<string>("78900204", result.ContractSheet.row[0].GetCellValue("UKPRN"));
            Assert.IsNull(result.ContractSheet.row[0].GetCellValue("ContractNumber"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExcelFileReader_LoadsAnExcelFileContractAllocationSheet()
        {
            ContractBulkUpload result;
            
            using (MemoryStream stream = new MemoryStream(_excelFile))
            {
                result = new ContractBulkUpload(_parser.ReadFile(stream, "TestFileName.xlsx"));
            }
            Assert.IsNotNull(result.ContractAllocationSheet);
            Assert.AreEqual<int>(3, result.ContractAllocationSheet.row.Length);
            Assert.AreEqual<int>(17, result.ContractAllocationSheet.row[0].cell.Length);
            Assert.AreEqual<string>("78900204", result.ContractAllocationSheet.row[0].GetCellValue("UKPRN"));
            Assert.IsNull(result.ContractAllocationSheet.row[0].GetCellValue("LEPName"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExcelFileReader_LoadsAnExcelFileContractDeliverableSheet()
        {
            ContractBulkUpload result;

            using (MemoryStream stream = new MemoryStream(_excelFile))
            {
                result = new ContractBulkUpload(_parser.ReadFile(stream, "TestFileName.xlsx"));
            }
            Assert.IsNotNull(result.ContractDeliverableSheet);
            Assert.AreEqual<int>(24, result.ContractDeliverableSheet.row.Length);
            Assert.AreEqual<int>(12, result.ContractDeliverableSheet.row[0].cell.Length);
            Assert.AreEqual<string>("78900204", result.ContractDeliverableSheet.row[0].GetCellValue("UKPRN"));
            Assert.AreEqual<string>("24+ ALLF", result.ContractDeliverableSheet.row[0].GetCellValue("FundingStreamCode"));
            Assert.IsNull(result.ContractDeliverableSheet.row[0].GetCellValue("Volume"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExcelFileReader_DoesNotLoadIfFileIsAPDFTest()
        {
            dataLoadResults result;

            using (MemoryStream stream = new MemoryStream(_pdfFile))
            {
                result = _parser.ReadFile(stream, "PDF.xlsx");
            }

            Assert.IsNull(result.workbook);
            Assert.AreEqual<int>(1, result.error.Length);
            Assert.AreEqual<string>("File type is not as expected. Expected file type is .xlsx", result.error[0].Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExcelFileReader_ShouldHandleExceptionWhenGivenSpreadsheetWithBlankSheet()
        {
            // arrange
            dataLoadResults dataLoadResults;
            byte[] invalidSpreadsheet;

            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 BlankDeliverableSheet.xlsx"))
            {
                invalidSpreadsheet = TestUtils.FileToByteArray(resource.Stream);
            }

            // act
            using (MemoryStream stream = new MemoryStream(invalidSpreadsheet))
            {
                dataLoadResults = _parser.ReadFile(stream, "BlankDeliverableSheet.xlsx");
            }

            // assert
            Assert.IsNotNull(dataLoadResults, "Returned dataLoadResults is null.");
            Assert.IsNull(dataLoadResults.workbook, "Returned dataLoadResults.workbook is not null.");
            Assert.AreEqual(1, dataLoadResults.error.Length, "Unexpected number of errors returned.");
            Assert.AreEqual("File format is not as expected.", dataLoadResults.error[0].Value, "Unexpected error message returned.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellNullableDecimal_ShouldReturnNullIfValueInColumnNameIsNull()
        {
            // arrange 
            cellType cell = new cellType {columnName = "UnitCost", Value = string.Empty};
            rowType row = new rowType { cell = new [] { cell }, id = "1", rowNumber = 1 };

            // act
            decimal? actual = row.GetCellNullableDecimal("UnitCost");

            // assert
            Assert.IsNull(actual, "Returned Value not null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellNullableDecimal_ShouldReturnNotNullIfValueInColumnNameIsNotNull()
        {
            // arrange 
            decimal? expected = 0.0m;
            cellType cell = new cellType { columnName = "UnitCost", Value = expected.ToString() };
            rowType row = new rowType { cell = new[] { cell }, id = "1", rowNumber = 1 };

            // act
            decimal? actual = row.GetCellNullableDecimal("UnitCost");

            // assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellNullableInt_ShouldReturnNullIfValueInColumnNameIsNull()
        {
            // arrange 
            cellType cell = new cellType { columnName = "UnitCost", Value = string.Empty };
            rowType row = new rowType { cell = new[] { cell }, id = "1", rowNumber = 1 };

            // act
            int? actual = row.GetCellNullableInt("UnitCost");

            // assert
            Assert.IsNull(actual, "Returned Value not null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellNullableInt_ShouldReturnNotNullIfValueInColumnNameIsNotNull()
        {
            // arrange 
            int? expected = 0;
            cellType cell = new cellType { columnName = "UnitCost", Value = expected.ToString() };
            rowType row = new rowType { cell = new[] { cell }, id = "1", rowNumber = 1 };

            // act
            int? actual = row.GetCellNullableInt("UnitCost");

            // assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellNullableInt_ShouldNotReturnNullIfValueIsIntegerWithDecimalPoint()
        {
            // arrange
            int? expected = 12;
            cellType cell = new cellType {columnName = "Volume", Value = "12.00"};
            rowType row = new rowType {cell = new[] {cell}, id = "1", rowNumber = 1};

            // act
            int? actual = row.GetCellNullableInt("Volume");

            // assert
            Assert.AreEqual(expected, actual);
        }

        // not nullable tests
        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellInt_ShouldReturnZeroIfValueInColumnNameIsNull()
        {
            // arrange 
            cellType cell = new cellType { columnName = "UnitCost", Value = null };
            rowType row = new rowType { cell = new[] { cell }, id = "1", rowNumber = 1 };

            // act
            int actual = row.GetCellInt("UnitCost");

            // assert
            Assert.AreEqual(0, actual);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellInt_ShouldReturnNotZeroIfValueInColumnNameIsNotNull()
        {
            // arrange 
            int expected = 25;
            cellType cell = new cellType { columnName = "UnitCost", Value = expected.ToString() };
            rowType row = new rowType { cell = new[] { cell }, id = "1", rowNumber = 1 };

            // act
            int? actual = row.GetCellInt("UnitCost");

            // assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellInt_ShouldNotReturnZeroIfValueIsIntegerWithDecimalPoint()
        {
            // arrange
            int expected = 12;
            cellType cell = new cellType {columnName = "Volume", Value = "12.00"};
            rowType row = new rowType {cell = new[] {cell}, id = "1", rowNumber = 1};

            // act
            int actual = row.GetCellInt("Volume");

            // assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellInt_ShouldReturnZeroIfValueIsDecimal()
        {
            // arrange
            cellType cell = new cellType { columnName = "Volume", Value = "12.5" };
            rowType row = new rowType { cell = new[] { cell }, id = "1", rowNumber = 1 };

            // act
            int actual = row.GetCellInt("Volume");

            // assert
            Assert.AreEqual(0, actual);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RowType_GetCellInt_ShouldReturnZeroIfValueIsNotParseable()
        {
            // arrange
            cellType cell = new cellType { columnName = "Volume", Value = "one" };
            rowType row = new rowType { cell = new[] { cell }, id = "1", rowNumber = 1 };

            // act
            int actual = row.GetCellInt("Volume");

            // assert
            Assert.AreEqual(0, actual);
        }
    }
}
