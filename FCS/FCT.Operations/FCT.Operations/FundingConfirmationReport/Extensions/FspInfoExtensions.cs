namespace FCT.Operations.FundingConfirmationReport.Extensions
{
    using System.Linq;
    using DTOs;

    public static class FspInfoExtensions
    {
        public static FspAllocationAndFunded ToFspAllocationAndFunded(
            this (string fspDesc, int order, PaymentMethod paymentMethod) fsp, ReportRow reportRow)
        {
            var matchingRow =
                reportRow.Fsps.SingleOrDefault(paymentInfoForFsp => paymentInfoForFsp.Desc == fsp.fspDesc);

            if (matchingRow == null)
            {
                return new FspAllocationAndFunded(string.Empty, fsp.fspDesc, 0, 0, fsp.order, fsp.paymentMethod);
            }

            return new FspAllocationAndFunded(string.Empty, fsp.fspDesc, matchingRow.AllocationValue,
                matchingRow.FundedValue, fsp.order, fsp.paymentMethod);
        }
    }
}
