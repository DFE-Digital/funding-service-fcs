namespace FCT.Console.Config.Excel
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Newtonsoft.Json.Linq;

    public class JsonWorksheetReader : IWorksheetReader
    {
        private readonly JArray _jArray;

        public JsonWorksheetReader(JArray jArray)
        {
            _jArray = jArray;
        }

        public IEnumerable<WorksheetRowReader> DataRows()
        {
            return _jArray.Select(r => new WorksheetRowReader(r)).ToList();
        }

        public IEnumerable<WorksheetRowReader> Rows() => throw new NotImplementedException();
        public string CellStringValue(string cellName) => throw new NotImplementedException();
        public DateTime CellDateValue(string cellName) => throw new NotImplementedException();
        public int GetNumberOfRows() => throw new NotImplementedException();
    }
}
