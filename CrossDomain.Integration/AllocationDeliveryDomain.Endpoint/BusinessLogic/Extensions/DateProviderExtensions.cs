namespace AllocationDeliveryDomain.Endpoint.BusinessLogic.Extensions
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Common;

    public static class DateProviderExtensions
    {
        public static string GetCurrentPeriod(this IDate dateProvider)
        {
            return dateProvider.GetCalculationDate().ToCurrentPeriod().ToCurrentPeriodFormat();
        }

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
