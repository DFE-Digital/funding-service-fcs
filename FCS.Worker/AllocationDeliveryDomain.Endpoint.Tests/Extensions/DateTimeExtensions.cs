using System;

namespace AllocationDeliveryDomain.Endpoint.Tests.Extensions
{
    public static class DateTimeExtensions
    {
        public static DateTime ToDateTimeWithoutMilliseconds(this DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second);
        }
    }
}
