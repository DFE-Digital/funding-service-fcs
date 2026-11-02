namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Reflection;
    using CrossDomain.Integration.Common.Extensions;
    using Infrastructure.DTO;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using TechTalk.SpecFlow;
    using Utilities;

    public static class TableRowExtensions
    {
        private const string CharacterRepresentingNull = "?";

        public static int ParseInt(this TableRow tableRow, string column)
        {
            return int.Parse(tableRow[column]);
        }

        public static int? ParseNullableInt(this TableRow tableRow, string column)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (!string.IsNullOrEmpty(columnValue) && columnValue != CharacterRepresentingNull && columnValue != "<Blank>")
                {
                    return (int)double.Parse(columnValue);
                }
            }

            return null;
        }

        public static decimal ParseDecimal(this TableRow tableRow, string column)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return decimal.Parse(columnValue);
                }
            }

            return 0;
        }

        public static decimal? ParseNullableDecimal(this TableRow tableRow, string column)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return decimal.Parse(columnValue);
                }
            }

            return null;
        }

        public static double ParseDouble(this TableRow tableRow, string column)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return double.Parse(columnValue);
                }
            }

            return 0;
        }

        public static float ParseFloat(this TableRow tableRow, string column)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return float.Parse(columnValue);
                }
            }

            return 0;
        }

        public static string ParseNullableString(this TableRow tableRow, string column)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return columnValue;
                }
            }

            return null;
        }

        public static string ParseNullableStringOrDefaultIfNotPresent(this TableRow tableRow, string column, string defaultVal)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return columnValue;
                }

                return null;
            }

            return defaultVal;
        }

        public static string ParseStringIfPresentElseEmpty(this TableRow tableRow, string column)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return columnValue;
                }
            }

            return string.Empty;
        }

        public static StringParseResult GetStringParseResult(this TableRow tableRow, string column)
        {
            bool isInTable = tableRow.ContainsKey(column);
            if (isInTable)
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return new StringParseResult(columnValue);
                }
            }

            return new StringParseResult(isInTable);
        }

        public static bool ParseBoolean(this TableRow tableRow, string column)
        {
            return tableRow.ParseNullableBoolean(column).Value;
        }

        public static bool? ParseNullableBoolean(this TableRow tableRow, string column)
        {
            string[] additionalTrueLiterals = { "YES", "Yes", "yes", "1" };
            string[] additionalFalseLiterals = { "NO", "No", "no", "0" };

            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    if (additionalTrueLiterals.Contains(columnValue))
                    {
                        return true;
                    }

                    if (additionalFalseLiterals.Contains(columnValue))
                    {
                        return false;
                    }

                    return bool.Parse(columnValue);
                }
            }

            return null;
        }

        public static DateTime ParseDate(this TableRow tableRow, string column, string format = "d/MM/yyyy")
        {
            string columnValue = tableRow[column];
            return DateTime.SpecifyKind(DateTime.ParseExact(columnValue, format, CultureInfo.InvariantCulture), DateTimeKind.Utc);
        }

        public static DateTime ParseDateAndTime(this TableRow tableRow, string column)
        {
            string columnValue = tableRow[column];
            return DateTime.SpecifyKind(DateTime.ParseExact(columnValue, "yyyy-MM-dd'T'HH:mm:ss'Z'", CultureInfo.InvariantCulture), DateTimeKind.Utc);
        }

        public static DateTime? ParseNullableDate(this TableRow tableRow, string column, string format = "d/MM/yyyy")
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return DateTime.SpecifyKind(DateTime.ParseExact(columnValue, format, CultureInfo.InvariantCulture), DateTimeKind.Utc);
                }
            }

            return null;
        }

        public static T ParseEnum<T>(this TableRow tableRow, string column)
        {
            return (T)Enum.Parse(typeof(T), tableRow[column].Replace(" ", string.Empty));
        }

        public static object ParseNullableEnum<T>(this TableRow tableRow, string column)
        {
            if (tableRow.ContainsKey(column))
            {
                string columnValue = tableRow[column];

                if (columnValue != CharacterRepresentingNull)
                {
                    return Enum.Parse(typeof (T), tableRow[column].Replace(" ", string.Empty));
                }
            }

            return null;
        }

        public static OptionSetValue ParseNullableOptionSetValue<T>(this TableRow tableRow, string column)
        {
            string columnValue = tableRow[column];

            if (columnValue != CharacterRepresentingNull)
            {
                T enumValue = (T)Enum.Parse(typeof(T), tableRow[column].Replace(" ", string.Empty));
                return new OptionSetValue(Convert.ToInt32(enumValue));
            }

            return null;
        }

        public static T CreateInstance<T>(this TableRow row) where T : new()
        {
            T instance = new T();
            PropertyInfo[] propertyInfos = typeof(T).GetProperties();

            propertyInfos.ForEach(p =>
            {
                if (row.Select(cell => cell.Key.ToUpper()).Contains(p.Name.ToUpper()))
                {
                    string tableRowValue = row.GetTableRowValueForPropertyNameIgnoreCase(p.Name);
                    if (tableRowValue == CharacterRepresentingNull)
                    {
                        p.SetValue(instance, null);
                    }
                    else if (p.PropertyType == typeof(int) || p.PropertyType == typeof(int?))
                    {
                        p.SetValue(instance, int.Parse(tableRowValue));
                    }
                    else if (p.PropertyType == typeof(decimal) || p.PropertyType == typeof(decimal?))
                    {
                        p.SetValue(instance, decimal.Parse(tableRowValue));
                    }
                    else if (p.PropertyType.IsEnum)
                    {
                        p.SetValue(instance, Enum.Parse(p.PropertyType, tableRowValue.Replace(" ", string.Empty)));
                    }
                    else
                    {
                        p.SetValue(instance, tableRowValue);
                    }
                }
            });

            return instance;
        }

        private static string GetTableRowValueForPropertyNameIgnoreCase(this TableRow row, string propertyName)
        {
            List<string> keys = row.Select(cell => cell.Key.ToUpper()).ToList();
            int positionOfMatchingKey = keys.IndexOf(propertyName.ToUpper());

            if (positionOfMatchingKey != -1)
            {
                return row.Values.ToList()[positionOfMatchingKey];
            }

            return null;
        }

        public static void CompareToInstance<T>(this TableRow row, T instance, bool treatEmptyAndNullStringsAsEquivalent = false) where T : new()
        {
            T rowInstance = row.CreateInstance<T>();
            PropertyInfo[] propertyInfos = typeof(T).GetProperties();

            propertyInfos.ForEach(p =>
            {
                object expectedValue = p.GetValue(rowInstance);
                object actualValue = p.GetValue(instance);

                if (treatEmptyAndNullStringsAsEquivalent && p.PropertyType == typeof(string))
                {
                    expectedValue = expectedValue != null && expectedValue.ToString() != string.Empty ? expectedValue : null;
                    actualValue = actualValue != null && actualValue.ToString() != string.Empty ? actualValue : null;
                }

                Assert.AreEqual(expectedValue, actualValue, $"Value incorrect for column: {p.Name} in row: {row.ToHeaderAndValueString()}");
            });
        }

        public static IReadOnlyCollection<PeriodValue> GetPeriodValues(this TableRow row)
        {
            return row
                .Where(cell => cell.IsPeriodColumn())
                .Select(cell => cell.ToPeriodValue())
                .ToList();
        }

        public static string ToHeaderAndValueString(this TableRow row)
        {
            return $"[{string.Join(", ", row.Select(cell => $"{cell.Key}: {cell.Value}"))}]";
        }

        public static string ToHeaderAndValueString(this IEnumerable<TableRow> rows)
        {
            return $"{string.Join(", ", rows.Select(r => r.ToHeaderAndValueString()))}";
        }

        public static IReadOnlyCollection<TableRow> PollForUnmatchedRows<TKey, TComparisonItem>(
            this IEnumerable<TableRow> rows,
            Func<TKey, TComparisonItem> getComparisonData,
            Func<TableRow, TKey> selectKey,
            Func<TComparisonItem, TableRow, bool> isMatchingRow,
            int maxNumChecks = 10,
            int waitIntervalSeconds = 2)
        {
            List<TableRow> unmatchedRows = new List<TableRow>();

            bool FindUnmatchedRows()
            {
                unmatchedRows = rows
                    .Where(row =>
                    {
                        TKey key = selectKey(row);
                        TComparisonItem comparisonItem = getComparisonData(key);
                        return comparisonItem == null || !isMatchingRow(comparisonItem, row);
                    })
                    .ToList();

                return unmatchedRows.None();
            }

            CheckResultPoller poller = new CheckResultPoller(FindUnmatchedRows, maxNumChecks, waitIntervalSeconds);
            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            return unmatchedRows;
        }

        public static bool ContainsColumnValue(this IEnumerable<TableRow> rows, string column, string value)
        {
            return rows.Select(row => row[column]).Contains(value);
        }
    }

    public class StringParseResult
    {
        public StringParseResult(bool isColumnPresent, string value)
        {
            Value = value;
            IsColumnPresent = isColumnPresent;
        }

        public StringParseResult(string value)
        {
            Value = value;
            IsColumnPresent = !string.IsNullOrEmpty(value);
        }

        public StringParseResult(bool isColumnPresent)
        {
            IsColumnPresent = isColumnPresent;
        }

        public bool IsColumnPresent { get; }

        public string Value { get; }

        public string ValueToCheck(string defaultValue)
        {
            if (IsColumnPresent)
            {
                return Value;
            }

            return defaultValue;
        }
    }
}
