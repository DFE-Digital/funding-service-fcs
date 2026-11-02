namespace FCT.Console.Config.Excel
{
    using System;
    using System.Collections.Generic;

    public interface IWorksheetReader
    {
        IEnumerable<WorksheetRowReader> DataRows();

        DateTime CellDateValue(string cellName);

        int GetNumberOfRows();

        string CellStringValue(string cellName);

        IEnumerable<WorksheetRowReader> Rows();
    }
}