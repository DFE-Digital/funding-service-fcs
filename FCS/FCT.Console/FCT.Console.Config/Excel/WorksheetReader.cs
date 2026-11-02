namespace FCT.Console.Config.Excel
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Aspose.Cells;

    public class WorksheetReader : IWorksheetReader
    {
        private readonly Worksheet _worksheet;
        public WorksheetReader(Worksheet worksheet)
        {
            _worksheet = worksheet;
        }

        public int GetNumberOfRows()
        {
            return _worksheet.Cells.GetLastDataRow(0) + 1;
        }

        public WorksheetRowReader WorksheetRowReader(int rowNumber)
        {
            return new WorksheetRowReader(_worksheet.Cells.Rows[rowNumber]);
        }

        public DateTime CellDateValue(string cellName)
        {
            return _worksheet.Cells[cellName].DateTimeValue;
        }

        public string CellStringValue(string cellName)
        {
            return _worksheet.Cells[cellName].StringValue;
        }

        public IEnumerable<WorksheetRowReader> Rows()
        {
            IList<WorksheetRowReader> rows = new List<WorksheetRowReader>();
            int numRows = GetNumberOfRows();
            for (int i = 0; i < numRows; i++)
            {
                rows.Add(WorksheetRowReader(i));
            }

            return rows;
        }

        public IEnumerable<WorksheetRowReader> DataRows()
        {
            return Rows().Skip(1).Where(row => !string.IsNullOrEmpty(row.CellStringValue(0)));
        }
    }
}
