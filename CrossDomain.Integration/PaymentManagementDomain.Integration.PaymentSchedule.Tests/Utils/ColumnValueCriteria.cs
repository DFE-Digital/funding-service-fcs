namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Utils
{
    using Microsoft.Xrm.Sdk.Query;

    public class ColumnValueCriteria
    {
        public ColumnValueCriteria(string columnName, ConditionOperator conditionOperator, object value)
        {
            ColumnName = columnName;
            ConditionOperator = conditionOperator;
            Value = value;
        }

        public string ColumnName { get; private set; }

        public ConditionOperator ConditionOperator { get; private set; }

        public object Value { get; private set; }

    }
}
