namespace FundingAllocation.Tests.Extensions
{
    using System;

    public static class DateTimeExtensions
    {
        public static bool AreEqualIgnoreMilliseconds(this DateTime? dateTime, DateTime other)
        {
            return dateTime.HasValue && dateTime.Value.Year == other.Year &&
                   dateTime.Value.Month == other.Month &&
                   dateTime.Value.Day == other.Day &&
                   dateTime.Value.Hour == other.Hour &&
                   dateTime.Value.Minute == other.Minute &&
                   dateTime.Value.Second == other.Second;
        }
    }
}
