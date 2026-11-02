namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System.Linq;
    using Aspose.Cells;
    using Extensions;
    using MoreLinq;
    using TechTalk.SpecFlow;

    [Binding]
    public static class FeatureVariables
    {
        public static string Get(string key)
        {
            return ScenarioContext.Current.Get<string>(key.TrimSquareBrackets());
        }

        public static void Set(string key, string value)
        {
            ScenarioContext.Current[key.TrimSquareBrackets()] = value;
        }

        public static void TransformFeatureVariables(this Workbook workbook)
        {
            workbook.Worksheets
                .SelectMany(sheet => sheet.Cells.Cast<Cell>())
                .Where(cell => cell.StringValue.Contains("["))
                .ForEach(cell =>
                {
                    cell.PutValue(cell.StringValue.TransformVariables());
                });
        }

        [StepArgumentTransformation]
        public static TransformedTable ToTransformedTable(Table table)
        {
            table.Rows.ForEach(row =>
            {
                row.ForEach(cell =>
                {
                    row[cell.Key] = cell.Value.TransformVariables();
                });
            });

            return new TransformedTable(table);
        }

        [StepArgumentTransformation]
        public static TransformedString ToTransformedString(string value)
        {
            return new TransformedString(value.TransformVariables());
        }

        [StepArgumentTransformation]
        public static SubStatus ToSubStatus(string subStatusString)
        {
            return subStatusString;
        }

        private static string TransformVariables(this string value)
        {
            if (value.Contains("["))
            {
                ScenarioContext.Current.ForEach(kvp =>
                {
                    string bracketedKey = kvp.Key.AddSquareBrackets();
                    value = value.Replace(bracketedKey, (string)kvp.Value);
                });
            }

            return value;
        }

        private static string AddSquareBrackets(this string value)
        {
            return $"[{value}]";
        }

        private static string TrimSquareBrackets(this string value)
        {
            return value.Replace("[", string.Empty).Replace("]", string.Empty);
        }
    }

    public class TransformedTable
    {
        public TransformedTable(Table transformedTable)
        {
            Value = transformedTable;
        }

        public static implicit operator Table(TransformedTable ts) => ts.Value;

        public Table Value { get; }

        public int RowCount => Value.RowCount;

        public TableRows Rows => Value.Rows;
    }

    public class TransformedString
    {
        public TransformedString(string transformedString)
        {
            Value = transformedString;
        }

        public string Value { get; }

        public static implicit operator string(TransformedString ts) => ts.Value;

        public override string ToString()
        {
            return Value;
        }
    }
}
