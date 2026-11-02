namespace FCT.Operations.FundingConfirmationReport.Extensions
{
    using System;

    public static class DecimalExtensions
    {
        public static decimal RoundToNearestPound(this decimal value)
        {
            return Math.Round(value, MidpointRounding.AwayFromZero);
        }
    }
}
