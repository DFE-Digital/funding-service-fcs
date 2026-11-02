namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    public class ContractDeliverablePeriodCdaInfo
    {
        public string Deliverable { get; set; }

        public int DeliverablePeriod { get; set; }

        public string PaymentPosted { get; set; }

        public decimal TotalNetPayment { get; set; }

        public string SubnominalReconciliation { get; set; }

        public override bool Equals(object obj)
        {
            if (obj is ContractDeliverablePeriodCdaInfo other)
            {
                return Deliverable == other.Deliverable &&
                       DeliverablePeriod == other.DeliverablePeriod &&
                       PaymentPosted == other.PaymentPosted &&
                       TotalNetPayment == other.TotalNetPayment &&
                       SubnominalReconciliation.ToEmptyIfNull() == other.SubnominalReconciliation.ToEmptyIfNull();
            }

            return false;
        }
    }

    public static class StringExtensions
    {
        public static string ToEmptyIfNull(this string text)
        {
            return text ?? string.Empty;
        }
    }
}