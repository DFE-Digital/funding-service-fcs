namespace FCT.Operations.Cda.Dtos
{
    using System.Collections.Generic;

    public class OpenAndClosedCdaRows
    {
        public OpenAndClosedCdaRows(List<CdaRow> openContractRows, IReadOnlyCollection<(int year, IReadOnlyCollection<CdaRow> closedContractRows)> closedYears)
        {
            OpenContractRows = openContractRows;
            ClosedYears = closedYears;
        }

        public List<CdaRow> OpenContractRows { get; }

        public IReadOnlyCollection<(int year, IReadOnlyCollection<CdaRow> closedContractRows)> ClosedYears { get; }
    }
}
