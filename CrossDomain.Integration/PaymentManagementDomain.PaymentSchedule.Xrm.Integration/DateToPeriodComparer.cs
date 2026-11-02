namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration
{
    using System;

    public static class DateToPeriodComparer
    {
        public static bool IsPeriodWithinDateRange(string period, DateTime startDateTime, DateTime endDateTime)
        {
            CheckArgument(() => period.Length == 6, "The period must be 6 chars e.g '201608'");

            DateTime periodDate = ConvertPeriodToDate(period);

            return periodDate >= startDateTime &&
                   periodDate <= endDateTime;
        }

        private static DateTime ConvertPeriodToDate(string period)
        {
            int month = int.Parse(period.Substring(4, 2));
            int year = int.Parse(period.Substring(0, 4));
            const int day = 1;

            return new DateTime(year, month, day);
        }

        private static void CheckArgument(Func<bool> isValid, string errorMessage)
        {
            if (!isValid())
            {
                throw new ArgumentException(errorMessage);
            }
        }
    }
}
