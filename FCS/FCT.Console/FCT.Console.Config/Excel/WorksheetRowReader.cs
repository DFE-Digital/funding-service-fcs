namespace FCT.Console.Config.Excel
{
    using System;
    using Aspose.Cells;
    using Newtonsoft.Json.Linq;

    public class WorksheetRowReader
    {
        private readonly Row _excelRow;
        private readonly JToken _jsonRow;

        public WorksheetRowReader(Row row)
        {
            _excelRow = row;
        }

        public WorksheetRowReader(JToken jsonRow)
        {
            _jsonRow = jsonRow;
        }

        public DateTime? CellNullableDateValue(int column, string propertyName)
        {
            if (isJsonRow())
            {
                var token = _jsonRow[propertyName];
                return IsNullOrEmpty(token) ? (DateTime?)null : TransformToUtc((DateTime)token);
            }
            return CellNullableDateValue(column);
        }

        public DateTime CellDateValue(int column, string propertyName)
        {
            var dateTime = isJsonRow() ? (DateTime)_jsonRow[propertyName] : _excelRow[column].DateTimeValue;
            return TransformToUtc(dateTime);
        }

        public decimal CellCurrencyValue(int column, string propertyName)
        {
            var currencyStr = isJsonRow() ? CellStringValue(propertyName) : _excelRow[column].StringValue;
            return decimal.Parse(currencyStr.Replace("£", ""));
        }

        public decimal CellDecimalValue(int column, string propertyName)
        {
            var decimalStr = isJsonRow() ? CellStringValue(propertyName) : CellStringValue(column);
            decimal.TryParse(decimalStr, out decimal cellDecimal);
            return cellDecimal;
        }

        public decimal? CellNullableCurrencyValue(int column, string propertyName)
        {
            if (isJsonRow())
            {
                var token = _jsonRow[propertyName];
                return IsNullOrEmpty(token) ? (decimal?)null : CellCurrencyValue(propertyName);
            }
            return CellNullableCurrencyValue(column);
        }

        public string CellStringValue(int column, string propertyName)
        {
            return isJsonRow() ? _jsonRow[propertyName].ToString() : _excelRow[column].StringValue.Trim();
        }

        public bool CellBooleanValue(int column, string propertyName)
        {
            return isJsonRow() ? _jsonRow[propertyName].ToString().ToLower() == "true" : CellBooleanValue(column);
        }

        public bool? CellBooleanValueNullIfEmpty(int column, string propertyName)
        {
            if (isJsonRow())
            {
                var token = _jsonRow[propertyName];
                return IsNullOrEmpty(token) ? null : (bool?)token;
            }
            return CellNullableBooleanValue(column);
        }

        public string CellStringValueNullIfEmpty(int column, string propertyName)
        {
            if (isJsonRow())
            {
                var token = _jsonRow[propertyName];
                return IsNullOrEmpty(token) ? null : (string)token;
            }
            return CellStringValueNullIfEmpty(column);
        }

        public string CellStringValue(int column)
        {
            return _excelRow[column].StringValue.Trim();
        }

        private string CellStringValueNullIfEmpty(int column)
        {
            string stringValue = CellStringValue(column);
            if (stringValue == string.Empty)
            {
                return null;
            }
            return stringValue;
        }

        public int CellIntValue(int column, string propertyName)
        {
            if (isJsonRow())
            {
                string cellIntAsString = CellStringValue(propertyName);
                int cellInt;
                int.TryParse(cellIntAsString, out cellInt);
                return cellInt;
            }
            return CellIntValue(column);
        }

        private DateTime? CellNullableDateValue(int column)
        {
            DateTime? cellValue = null;
            if (_excelRow[column].Value != null)
            {
                cellValue = TransformToUtc(_excelRow[column].DateTimeValue);
            }
            return cellValue;
        }

        private decimal CellCurrencyValue(int column)
        {
            return decimal.Parse(_excelRow[column].StringValue.Replace("£", ""));
        }

        private decimal CellCurrencyValue(string propertyName)
        {
            return decimal.Parse(CellStringValue(propertyName).Replace("£", ""));
        }

        private decimal? CellNullableCurrencyValue(int column)
        {
            if (_excelRow[column].Value != null)
            {
                return CellCurrencyValue(column);
            }
            return null;
        }

        private bool CellBooleanValue(int column)
        {
            string stringValue = CellStringValue(column);
            return stringValue.ToUpper() == "YES" || stringValue == "1";
        }

        private bool? CellNullableBooleanValue(int column)
        {
            if (_excelRow[column].Value != null)
            {
                return CellBooleanValue(column);
            }
            return null;
        }

        private int CellIntValue(int column)
        {
            string cellIntAsString = CellStringValue(column);
            int cellInt;
            int.TryParse(cellIntAsString, out cellInt);
            return cellInt;
        }

        public int? NullableIntValue(int column, string propertyName)
        {
            if (isJsonRow())
            {
                string cellIntAsString = CellStringValue(propertyName);

                if (string.IsNullOrEmpty(cellIntAsString))
                {
                    return null;
                }

                int.TryParse(cellIntAsString, out var cellInt);
                return cellInt;
            }

            return NullableIntValue(column);
        }

        private int? NullableIntValue(int column)
        {
            string cellIntAsString = CellStringValue(column);

            if (string.IsNullOrEmpty(cellIntAsString))
            {
                return null;
            }

            int.TryParse(cellIntAsString, out var cellInt);
            return cellInt;
        }

        private static bool IsNullOrEmpty(JToken token)
        {
            return token == null || string.IsNullOrWhiteSpace(token.ToString());
        }

        private string CellStringValue(string propertyName)
        {
            return (string)_jsonRow[propertyName];
        }

        private bool isJsonRow()
        {
            return _excelRow == null;
        }

        private DateTime TransformToUtc(DateTime localDateTime)
        {
            return new DateTime(
                year: localDateTime.Year,
                month: localDateTime.Month,
                day: localDateTime.Day,
                hour: localDateTime.Hour, 
                minute: localDateTime.Minute,
                second:0,
                kind:DateTimeKind.Utc);
        }
    }
}
