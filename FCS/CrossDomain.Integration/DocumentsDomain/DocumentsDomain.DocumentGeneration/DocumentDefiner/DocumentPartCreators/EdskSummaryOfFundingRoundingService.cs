namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators
{
    using System;
    using Appendix1;

    public static class EdskSummaryOfFundingRoundingService
    {
        /// <summary>
        /// The total and the period with the lowest pence value should be truncated.
        /// The remaining period is calculated as the difference between them.
        /// </summary>
        public static EdskSummaryRowResult GetSummaryRowResult(decimal periodOne, decimal periodTwo, decimal total, string fundingStreamPeriodCode)
        {
            if (fundingStreamPeriodCode == "1619ED1920")
            {
                return RoundValues(periodOne, periodTwo, total);
            }

            return new EdskSummaryRowResult(periodOne, periodTwo, total);
        }

        private static EdskSummaryRowResult RoundValues(decimal periodOne, decimal periodTwo, decimal total)
        {
            decimal truncatedTotal = decimal.Truncate(total);

            decimal periodOnePence = periodOne - decimal.Truncate(periodOne);
            decimal periodTwoPence = periodTwo - decimal.Truncate(periodTwo);

            if (Math.Abs(periodOnePence) <= Math.Abs(periodTwoPence))
            {
                periodOne = decimal.Truncate(periodOne);
                periodTwo = truncatedTotal - periodOne;
            }
            else
            {
                periodTwo = decimal.Truncate(periodTwo);
                periodOne = truncatedTotal - periodTwo;
            }

            return new EdskSummaryRowResult(periodOne, periodTwo, truncatedTotal);
        }
    }
}
