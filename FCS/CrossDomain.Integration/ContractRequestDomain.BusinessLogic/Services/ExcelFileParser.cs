namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.IO;
    using System.Xml.Serialization;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using Aspose.Cells;
    using Interfaces;
    using CrossDomain.Integration.Common;

    public class ExcelFileParser : IExcelFileParser
    {
        public dataLoadResults ReadFile(Stream fileStream, string fileName)
        {
            List<sheetType> sheets = new List<sheetType>();
            dataLoadResults results =  new dataLoadResults()
            {
                batchId = Guid.NewGuid().ToString(),
                fileName = fileName
            };

            try
            {
                using (Stream licenseStream = LicenseManager.GetAsposeLicense())
                {
                    License license = new License();
                    license.SetLicense(licenseStream);
                }

                Workbook wb = new Workbook(fileStream);
                foreach (Worksheet sheet in wb.Worksheets)
                {
                    sheets.Add(Translate(sheet));
                }

                results.workbook = sheets.ToArray();
            }
            catch (CellsException exp)
            {
                System.Diagnostics.Trace.WriteLine("CellsException thrown : " + exp.Message);
                System.Diagnostics.Trace.WriteLine(exp);

                results.error = new errorInfo[]
                {
                    new errorInfo() {Value = "File type is not as expected. Expected file type is .xlsx"}
                };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine($"{ex.GetType().Name} thrown : " + ex.Message);
                System.Diagnostics.Trace.WriteLine(ex);

                results.error = new[]
                {
                    new errorInfo
                    {
                        Value = "File format is not as expected."
                    }
                };
            }

            return results;
        }

        private sheetType Translate(Worksheet sheet)
        {
            int numColumns = sheet.Cells.Rows[0].LastCell.Column + 1;
            int numRows = sheet.Cells.GetLastDataRow(0) + 1;
            List<rowType> rows = new List<rowType>();

            for (int i = 1; i < numRows; i++)
            {
                if (!IsRowBlank(sheet.Cells.Rows[i], numColumns))
                {
                    rows.Add(Translate(sheet.Cells.Rows[i], numColumns, sheet));
                }
            }

            return new sheetType()
            {
                name = sheet.Name.Trim(),
                row = rows.ToArray()
            };
        }

        private bool IsRowBlank(Row row, int numColumnsToExpect)
        {
            for (int i = 0; i < numColumnsToExpect; i++)
            {
                if (!string.IsNullOrWhiteSpace(row[i].StringValue))
                {
                    return false;
                }
            }
            
            return true;
        }

        private rowType Translate(Row row, int numColumnsToExpect, Worksheet sheet)
        {
            List<cellType> cells = new List<cellType>();
            for (int i = 0; i < numColumnsToExpect; i++)
            {
                string value;
                if (row[i].Type == CellValueType.IsDateTime)
                {
                    value = row[i].DateTimeValue.ToString("dd/MM/yyyy"); 
                }
                else
                {
                    value = row[i].StringValue.Trim();
                }
                
                cells.Add(new cellType()
                {
                    columnName = sheet.Cells.Rows[0][i].StringValue.Trim().Replace(" ", string.Empty),
                    Value = value
                });
            }

            return new rowType()
            {
                id = Guid.NewGuid().ToString(),
                rowNumber = row.Index,
                cell = cells.ToArray()
            };
        }
    }
}
