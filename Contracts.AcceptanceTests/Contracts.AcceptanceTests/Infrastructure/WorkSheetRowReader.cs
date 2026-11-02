namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure
{
    using Aspose.Cells;

    public class WorksheetRowReader
    {
        private readonly Row _row;

        public WorksheetRowReader(Row row)
        {
            _row = row;
        }

        public string this[int columnIndex] => _row[columnIndex].StringValue.Trim();
    }
}
