namespace PMD.IntegrationTests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using Dtos;
    using TechTalk.SpecFlow;

    public static class TableRowExtensions
    {
        public static int ParseInt(this TableRow tableRow, string column)
        {
            return int.Parse(tableRow[column]);
        }

        public static DateTime ParseDate(this TableRow tableRow, string column, string format = "d/MM/yyyy")
        {
            string columnValue = tableRow[column];
            return DateTime.SpecifyKind(DateTime.ParseExact(columnValue, format, CultureInfo.InvariantCulture), DateTimeKind.Utc);
        }

        public static T ParseEnum<T>(this TableRow tableRow, string column)
        {
            return (T)Enum.Parse(typeof(T), tableRow[column].Replace(" ", string.Empty));
        }

        public static IReadOnlyCollection<PeriodValue> GetPeriodValues(this TableRow row)
        {
            return row
                .Where(cell => cell.IsPeriodColumn())
                .Select(cell => cell.ToPeriodValue())
                .ToList();
        }
    }
}
