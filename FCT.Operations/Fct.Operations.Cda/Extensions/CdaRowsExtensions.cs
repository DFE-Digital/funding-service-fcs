namespace FCT.Operations.Cda.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public static class CdaRowsExtensions
    {
        public static OpenAndClosedCdaRows SplitToOpenAndClosed(
                this IReadOnlyCollection<CdaRow> cdaRows,
                IReadOnlyCollection<(string contractNumber, int year)> closedContractWithYearItems)
        {
            var contractNumberLookup = cdaRows.ToLookup(cda => cda.ContractNumber);
            var contractNumbers = contractNumberLookup.Select(g => g.Key);

            var closedByYear = closedContractWithYearItems.GroupBy(c => c.year).Select(grp =>
                {
                    var closedCdaRowsInYear = grp.SelectMany(contractNumberInYear =>
                            contractNumberLookup[contractNumberInYear.contractNumber])
                        .ToList();

                    return (year: grp.Key, closedContractRows: (IReadOnlyCollection<CdaRow>)closedCdaRowsInYear);
                }).Where(closedYear => closedYear.closedContractRows.Any())
                .ToList();

            var openContractNumbers =
                contractNumbers.WhereNotIn(closedContractWithYearItems.Select(c => c.contractNumber));

            var openCdaRows =
                openContractNumbers.SelectMany(openContractNumber => contractNumberLookup[openContractNumber]).ToList();

            return new OpenAndClosedCdaRows(openCdaRows, closedByYear);
        }
    }
}
