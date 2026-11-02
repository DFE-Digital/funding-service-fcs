namespace SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload
{
    using System;
    using System.Linq;
    using System.Diagnostics.CodeAnalysis;
    using System.Globalization;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter")]
    public partial class rowType
    {
        public string GetCellValue(string columnName)
        {
            cellType cll = cell.FirstOrDefault<cellType>(c => c.columnName == columnName);
            if (cll != null && !string.IsNullOrEmpty(cll.Value))
            {
                return cll.Value;
            }
            else
            {
                return null;
            }
        }

        public int GetCellInt(string columnName)
        {
            int i;
            string s = GetCellValue(columnName);
            if (s != null && IsInteger(s, out i))
            {
                return i;
            }

            return 0;
        }

        public int? GetCellNullableInt(string columnName)
        {
            int i;
            string s = GetCellValue(columnName);
            if (s != null && IsInteger(s, out i))
            {
                return i;
            }

            return null;
        }

        public decimal GetCellDecimal(string columnName)
        {
            decimal d;
            string s = GetCellValue(columnName);
            return (s != null && decimal.TryParse(s, out d)) ? d : 0.0m;
        }

        public decimal? GetCellNullableDecimal(string columnName)
        {
            decimal d;
            string s = GetCellValue(columnName);
            if (s != null && decimal.TryParse(s, out d))
            {
                return d;
            }

            return null;
        }

        public DateTime? GetCellDateTime(string columnName)
        {
            string s = GetCellValue(columnName);
            DateTime? dt = GetDateTime(s);
            return dt;
        }

        public DateTime? GetDateTime(string dateValue)
        {
            DateTime dt;
            if (dateValue != null && DateTime.TryParseExact(dateValue, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out dt))
            {
                return dt.ToUniversalTime();
            }
            else
            {
                return null;
            }
        }

        public T GetCellEnum<T>(string columnName, T defaultValue) where T : struct, IConvertible
        {
            T t;
            string s = GetCellValue(columnName);
            //// strip spaces
            if (s != null && Enum.TryParse<T>(s.Replace(" ", string.Empty), out t))
            {
                return t;
            }
            else
            {
                return defaultValue;
            }
        }

        private bool IsInteger(string s, out int value)
        {
            bool isNumber = false;
            int valueAsInt = 0;
            decimal intermediateValue;

            if (decimal.TryParse(s, out intermediateValue))
            {
                isNumber = true;
                valueAsInt = (int)intermediateValue;
            }

            bool isNoRemainder = intermediateValue - valueAsInt == 0;
            
            value = valueAsInt;
            return isNumber && isNoRemainder;
        }
    }
}