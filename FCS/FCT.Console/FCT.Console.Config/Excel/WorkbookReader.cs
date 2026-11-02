namespace FCT.Console.Config.Excel
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Aspose.Cells;

    public class WorkbookReader : IWorkbookReader
    {
        private readonly Workbook _workbook;

        public WorkbookReader(string fileName)
        {
            _workbook = new Workbook(fileName);
        }

        public WorkbookReader(Stream stream)
        {
            _workbook = new Workbook(stream);
        }

        public IReadOnlyCollection<string> SheetNames()
        {
            return _workbook.Worksheets.Select(ws => ws.Name).ToList();
        }

        public IWorksheetReader WorksheetReader(string workSheetName)
        {
            return new WorksheetReader(_workbook.Worksheets[workSheetName]);
        }

        // this method is left in simply for compilation, it is redundant
        public void Dispose() { }
    }
}
