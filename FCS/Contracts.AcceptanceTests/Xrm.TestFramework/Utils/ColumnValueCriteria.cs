namespace SFA.FCT.Xrm.TestFramework.Utils
{
    using Microsoft.Xrm.Sdk.Query;

    public class ColumnValueCriteria
    {
        /*public ColumnValueCriteria(string columnName, ConditionOperator conditionOperator, object value)
        {
            ColumnName = columnName;
            ConditionOperator = conditionOperator;
            Value = value;
        }*/

        public ColumnValueCriteria(string columnName, ConditionOperator conditionOperator, params object[] values)
        {
            ColumnName = columnName;
            ConditionOperator = conditionOperator;
            Values = values;
        }

        public string ColumnName { get; private set; }

        public ConditionOperator ConditionOperator { get; private set; }

        public object[] Values { get; private set; }
    }
}