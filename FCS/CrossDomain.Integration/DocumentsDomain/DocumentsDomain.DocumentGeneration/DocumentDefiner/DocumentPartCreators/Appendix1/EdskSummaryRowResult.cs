namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1
{
    public class EdskSummaryRowResult
    {
        public EdskSummaryRowResult(decimal periodOne, decimal periodTwo, decimal total)
        {
            PeriodOne = periodOne;
            PeriodTwo = periodTwo;
            Total = total;
        }

        public decimal PeriodOne { get; }

        public decimal PeriodTwo { get; }

        public decimal Total { get; }
    }
}
