namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;

    public class ColumnValue
    {
        public string Table { get; set; }

        public string Column { get; set; }

        public object Value { get; set; }

        public Type ColumnType { get; set; }

        public string Alias { get; set; }

        public string GetColumnNameWithAlias()
        {
            if (!string.IsNullOrEmpty(Alias))
            {
                return Alias + "." + Column;
            }
            else
            {
                return Column;
            }
        }

        public override int GetHashCode()
        {
            return Column.GetHashCode() + Value.GetHashCode();
        }

        public override bool Equals(object obj)
        {
            bool isEqual = false;
            ColumnValue other = obj as ColumnValue;
            if (other != null)
            {
                isEqual = other.Column == Column && other.Value.Equals(Value);
            }

            return isEqual;
        }
    }
}