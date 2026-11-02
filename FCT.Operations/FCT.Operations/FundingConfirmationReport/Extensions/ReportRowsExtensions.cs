namespace FCT.Operations.FundingConfirmationReport.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;

    public static class ReportRowsExtensions
    {
        public static IReadOnlyCollection<(string fspDesc, int order, PaymentMethod paymentMethod)> GetDistinctFspsAndOrder(
            this IReadOnlyCollection<ReportRow> rows)
        {
            return rows.SelectMany(r => r.Fsps)
                .Select(fsp => (fsp.Desc, fsp.Order, fsp.PaymentMethod))
                .ToHashSet();
        }
    }
}
