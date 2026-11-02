namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System.IO;
    using System.Linq;
    using Aspose.Cells;
    using CrossDomain.Integration.Common;

    public static class ExcelHelper
    {
        static ExcelHelper()
        {
            using (Stream licenseStream = LicenseManager.GetAsposeLicense())
            {
                License license = new License();
                license.SetLicense(licenseStream);
            }
        }

        public static string GetCellValue(string fileName, string sheetName, string cellName)
        {
            return GetCellValue(new Workbook(fileName), sheetName, cellName);
        }

        public static string GetCellValue(Workbook workbook, string sheetName, string cellName)
        {
            Worksheet worksheet = workbook.Worksheets.FirstOrDefault(s => s.Name == sheetName);

            return GetCellValue(worksheet, cellName);
        }

        private static string GetCellValue(Worksheet worksheet, string cellName)
        {
            string value = null;
            int row;
            int column;
            CellsHelper.CellNameToIndex(cellName, out row, out column);
            Cell cell = worksheet.Cells.Rows[row][column];

            if (cell != null)
            {
                if (cell.Type == CellValueType.IsDateTime)
                {
                    value = cell.DateTimeValue.ToString("dd/MM/yyyy");
                }
                else
                {
                    value = cell.StringValue;
                }
            }

            return value;
        }
    }
}
