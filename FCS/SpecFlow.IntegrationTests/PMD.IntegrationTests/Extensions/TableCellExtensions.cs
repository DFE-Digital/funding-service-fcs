namespace PMD.IntegrationTests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using Dtos;

    public static class TableCellExtensions
    {
        public static bool IsPeriodColumn(this KeyValuePair<string, string> cell)
        {
            return DateTime.TryParseExact(cell.Key, "MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out _);
        }

        public static PeriodValue ToPeriodValue(this KeyValuePair<string, string> cell)
        {
            return new PeriodValue(cell.Key, ParseNullableDecimal(cell.Value));
        }

        private static decimal? ParseNullableDecimal(string value)
        {
            if (value == "?")
            {
                return null;
            }

            return decimal.Parse(value);
        }
    }
}
