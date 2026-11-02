namespace FCT.Console.Config.Excel
{
    using System.Collections.Generic;

    public interface IWorkbookReader
    {
        IReadOnlyCollection<string> SheetNames();

        IWorksheetReader WorksheetReader(string workSheetName);
    }
}