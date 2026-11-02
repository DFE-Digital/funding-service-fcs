namespace FCT.Console.Config.Dtos
{
    using Newtonsoft.Json.Linq;
    using System;

    public class SheetToRowsTransform
    {
        public SheetToRowsTransform(string sheetName, Func<string, object> rows)
        {
            SheetName = sheetName;
            GetRows = rows;
        }

        public string SheetName { get; }

        public Func<string, object> GetRows { get; }
    }
}