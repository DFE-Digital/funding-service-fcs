namespace SFA.FCT.Operations.Integrity.Extensions
{
    using System;
    using CrossDomain.Integration.Common;

    public static class DateProviderExtensions
    {
        public static string GetCurrentPeriod(this IDate dateProvider, DateTime currentDate)
        {
            return currentDate.ToCurrentPeriod().ToCurrentPeriodFormat();
        }

        private static DateTime ToCurrentPeriod(this DateTime currentDate)
        {
            return currentDate.AddMonths(-1);
        }

        private static string ToCurrentPeriodFormat(this DateTime currentPeriod)
        {
            return currentPeriod.ToString("yyyyMM");
        }
    }
}
