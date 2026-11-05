namespace ContractRequestDomain.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    public class ContractBulkUploadTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SheetProperties_ReturnMatchingWorkbookSheets()
        {
            var controlSheet = new sheetType { name = ContractBulkUpload.ControlSheetFieldName };
            var contractSheet = new sheetType { name = ContractBulkUpload.ContractsSheetFieldName };
            var allocationSheet = new sheetType { name = ContractBulkUpload.ContractAllocationSheetFieldName };
            var deliverableSheet = new sheetType { name = ContractBulkUpload.ContractDeliverableSheetFieldName };
            var upload = new ContractBulkUpload(new dataLoadResults
            {
                workbook = new[] { controlSheet, contractSheet, allocationSheet, deliverableSheet }
            });

            Assert.AreSame(controlSheet, upload.ControlSheet);
            Assert.AreSame(contractSheet, upload.ContractSheet);
            Assert.AreSame(allocationSheet, upload.ContractAllocationSheet);
            Assert.AreSame(deliverableSheet, upload.ContractDeliverableSheet);
            Assert.IsNull(upload.BaseClass.GetSheet("Missing"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellValue_ReturnsRequestedCellFromRequestedRow()
        {
            var sheet = new sheetType
            {
                row = new[]
                {
                    new rowType { cell = new[] { new cellType { columnName = "Code", Value = "A" } } },
                    new rowType { cell = new[] { new cellType { columnName = "Code", Value = "B" } } }
                }
            };

            var result = new ContractBulkUpload(new dataLoadResults()).GetCellValue(sheet, "Code", 1);

            Assert.AreEqual("B", result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellValue_WhenCellIsMissing_ThrowsCellNotFoundError()
        {
            var sheet = new sheetType
            {
                row = new[]
                {
                    new rowType { cell = new[] { new cellType { columnName = "Other", Value = "value" } } }
                }
            };

            var exception = CaptureException(
                () => new ContractBulkUpload(new dataLoadResults()).GetCellValue(sheet, "Code", 0));

            Assert.AreEqual("Cell value not found.", exception.Message);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetCellValue_WhenRowIsMissing_ThrowsRowNotFoundError()
        {
            var sheet = new sheetType { row = new rowType[0] };

            var exception = CaptureException(
                () => new ContractBulkUpload(new dataLoadResults()).GetCellValue(sheet, "Code", 0));

            Assert.AreEqual("Row not found.", exception.Message);
        }

        private static Exception CaptureException(Action action)
        {
            try
            {
                action();
            }
            catch (Exception exception)
            {
                return exception;
            }

            Assert.Fail("Expected an exception to be thrown.");
            return null;
        }
    }
}
