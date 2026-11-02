namespace PaymentManagement.Calculation.Extensions
{
    using System;

    public static class DecimalExtensions
    {
        public static decimal RoundPoundsToNearestPenny(this decimal pounds)
        {
            return Math.Round(pounds, 2);
        }

        public static decimal RoundPoundsDownToNearestPenny(this decimal pounds)
        {
            var pence = pounds.ToAbsolute() * 100;
            var wholePence  = Math.Floor(pence);
            var absolute = wholePence / 100;

            return pounds.IsNegative() ? absolute.ToNegative() : absolute;
        }

        public static decimal ToAbsolute(this decimal pounds)
        {
            return Math.Abs(pounds);
        }

        public static decimal ToNegative(this decimal pounds)
        {
            return pounds * -1;
        }

        public static bool IsNegative(this decimal? pounds)
        {
            return pounds < 0;
        }

        public static bool IsNegative(this decimal pounds)
        {
            return pounds < 0;
        }
    }
}
