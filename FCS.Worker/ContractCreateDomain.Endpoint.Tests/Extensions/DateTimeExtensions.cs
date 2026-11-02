namespace ContractCreateDomain.Endpoint.Tests.Extensions
{
    using System;

    public static class DateTimeExtensions
    {
        public static DateTime ToDateTimeWithoutMilliseconds(this DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second);
        }

        public static DateTime ToDateTimeWithoutSeconds(this DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute, 0);
        }

        public static DateTime ToDateTimeWithoutMinutes(this DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, 0, 0);
        }
    }
}