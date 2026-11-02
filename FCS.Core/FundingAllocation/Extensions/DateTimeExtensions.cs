namespace FundingAllocation.Extensions
{
    using System;

    public static class DateTimeExtensions
    {
        public static int ToPeriod(this DateTime dateTime)
        {
            return dateTime.Year * 100 + dateTime.Month;
        }

        /// <summary>
        /// e.g 'Aug-21'
        /// </summary>
        public static string ToPeriodString(this DateTime dateTime)
        {
            return dateTime.ToString("MMM-yy");
        }
    }
}
