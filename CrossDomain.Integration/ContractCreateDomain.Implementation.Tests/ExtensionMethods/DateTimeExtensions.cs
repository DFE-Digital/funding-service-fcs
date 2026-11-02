namespace ContractCreateDomain.Implementation.Tests.ExtensionMethods
{
    using System;
    public static class DateTimeExtensions
    {
        public static bool IsDateTimeEqualTo(this DateTime expected, DateTime? actual)
        {
            return (actual.HasValue && (expected.Year == actual.Value.Year)
                    && (expected.Month == actual.Value.Month)
                    && (expected.Day == actual.Value.Day)
                    && (expected.Hour == actual.Value.Hour)
                    && (expected.Minute == actual.Value.Minute)
                    && (expected.Second == actual.Value.Second));
        }

        public static bool IsDateEqualTo(this DateTime expected, DateTime? actual)
        {
            return (actual.HasValue && (expected.Year == actual.Value.Year)
                                    && (expected.Month == actual.Value.Month)
                                    && (expected.Day == actual.Value.Day));
        }
    }
}
