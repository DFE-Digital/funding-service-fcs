namespace ContractRequestDomain.Tests
{
    extern alias CSICommon;
    using System;
    using System.Linq;
    using Aspose.Cells;
    using System.IO;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common;

    public class ExcelHelper 
    {
        static public string GetCellValue(byte[] filedata, string sheetName, int row, int column)
        {
            using (MemoryStream stream = new MemoryStream(filedata))
            {
                using (Stream licenseStream = LicenseManager.GetAsposeLicense())
                {
                    License license = new License();
                    license.SetLicense(licenseStream);
                }
                Workbook wb = new Workbook(stream);
                Worksheet sheet = wb.Worksheets[sheetName];
                if(sheet != null)
                {
                    if (column <= sheet.Cells.MaxColumn && row <= sheet.Cells.MaxRow)
                    {
                        return sheet.Cells.Rows[row][column].StringValue.Trim();
                    }
                }

                return null;
            }
        }

    }
}
