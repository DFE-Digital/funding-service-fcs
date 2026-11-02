namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using DTO;

    public static class CdaReportComparisonObjectComparisonService
    {
        public static IReadOnlyCollection<string> CompareObjects(CdaReportComparisonObject expected, CdaReportComparisonObject found)
        {
            return expected.GetType().GetProperties().Select(prop => ComparePropertyOnEachObject(prop, expected, found))
                .Where(error => error != string.Empty)
                .ToList();
        }

        private static string ComparePropertyOnEachObject(PropertyInfo prop, CdaReportComparisonObject expected, CdaReportComparisonObject found)
        {
            string compareResultStr = string.Empty;

            string expectedPropertyValue = prop.GetValue(expected, null) as string;

            string foundPropertyValue = prop.GetValue(found, null) as string;

            if (expectedPropertyValue != foundPropertyValue)
            {
                DecimalParseResult expectedDecimalParseResult = ParseStringToDecimal(expectedPropertyValue);

                DecimalParseResult foundDecimalParseResult = ParseStringToDecimal(foundPropertyValue);

                if (!AreValuesDecimallyEquivalent(expectedDecimalParseResult, foundDecimalParseResult))
                {
                    return $"Expected value of '{expectedPropertyValue}' does not equal value found '{foundPropertyValue}' for {prop.Name} on row {expected}";
                }
                // else they are both a decimal and are equal   
            }

            return compareResultStr;
        }

        private static bool AreValuesDecimallyEquivalent(DecimalParseResult expectedDecimalParseResult,
            DecimalParseResult foundDecimalParseResult)
        {
            return (expectedDecimalParseResult.IsDecimal || foundDecimalParseResult.IsDecimal) &&
                   expectedDecimalParseResult.GetValueOrDefault() == foundDecimalParseResult.GetValueOrDefault();
        }

        private static DecimalParseResult ParseStringToDecimal(string str)
        {
            decimal val;
            return new DecimalParseResult(decimal.TryParse(str, out val), val, str);
        }

        private class DecimalParseResult
        {
            public DecimalParseResult(bool isDecimal, decimal decimalValue, string text)
            {
                IsDecimal = isDecimal;
                DecimalValue = decimalValue;
                Text = text;
            }

            public bool IsDecimal { get; }

            public decimal DecimalValue { get; }

            public string Text { get; }

            public decimal GetValueOrDefault()
            {
                if (!IsDecimal && Text == string.Empty)
                {
                    return 0;
                }

                return DecimalValue;
            }
        }
    }
}
