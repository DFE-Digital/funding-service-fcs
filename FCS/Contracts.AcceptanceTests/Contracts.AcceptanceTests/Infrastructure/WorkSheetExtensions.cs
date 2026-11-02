namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure
{
    using Aspose.Cells;

    public static class WorkSheetExtensions
    {
        public static Row GetRow(this Worksheet sheet, int columnToSearch, string valueToFind)
        {
            foreach (Row row in sheet.Cells.Rows)
            {
                if (row[columnToSearch].Value.Equals(valueToFind))
                {
                    return row;
                }    
            }

            return null;
        }
    }
}
