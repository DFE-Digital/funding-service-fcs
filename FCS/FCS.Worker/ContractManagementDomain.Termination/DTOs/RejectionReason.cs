namespace ContractManagementDomain.Termination.DTOs
{
    public class RejectionReason
    {
        public enum Why
        {
            NotSet,
            IsNotLatest,
            TerminationDateIsNotValid,
            HasOutstandingPayments,
            DuringMonthEnd
        }
        public RejectionReason(string text, Why whyFailed)
        {
            Text = text;
            WhyFailed = whyFailed;
        }

        public string Text { get; }

        public Why WhyFailed { get; }
    }
}