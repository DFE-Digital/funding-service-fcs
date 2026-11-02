namespace PerformanceManagement.IntegrationTests.Extensions
{
    using System;
    using TechTalk.SpecFlow;

    public static class TableRowExtensions
    {
        public static T ParseEnum<T>(this TableRow tableRow, string column, bool isUpperCaseRequired = false)
        {
            string columnText = tableRow[column];
            if (isUpperCaseRequired)
            {
                columnText = columnText.ToUpper();
            }
            return (T)Enum.Parse(typeof(T), columnText.Replace(" ", string.Empty));
        }
    }
}
