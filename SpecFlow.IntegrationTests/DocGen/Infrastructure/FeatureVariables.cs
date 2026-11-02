namespace DocGenTests.Infrastructure
{
    using System.Linq;
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

        [StepArgumentTransformation]
        public static TransformedTable ToTransformedTable(Table table)
        {
            table.Rows.ToList().ForEach(row =>
            {
                row.ToList().ForEach(cell =>
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

        private static string TransformVariables(this string value)
        {
            if (value.Contains("["))
            {
                ScenarioContext.Current.ToList().ForEach(kvp =>
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

        public override string ToString()
        {
            return Value;
        }
    }
}
