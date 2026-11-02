namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System.Collections.Generic;
    using Persistence;

    /// <summary>
    /// This class holds the data and column names (Column Values) of a CRM entity's primary key
    /// where the pk is made up of multiple values (composite)
    /// </summary>
    public class CrmCompositeKey
    {
        public CrmCompositeKey()
        {
            KeyFields = new List<ColumnValue>();
        }

        public IList<ColumnValue> KeyFields { get; set; }

        public override bool Equals(object obj)
        {
            bool isEqual = false;
            CrmCompositeKey other = obj as CrmCompositeKey;
            if (other != null && other.KeyFields.Count == KeyFields.Count)
            {
                // they have the same number now check the content
                isEqual = true;
                foreach (var otherKeyField in other.KeyFields)
                {
                    if (!KeyFields.Contains(otherKeyField))
                    {
                        isEqual = false;
                    }    
                }
            }

            return isEqual;
        }

        public override int GetHashCode()
        {
            int hashCode = 0;
            
            foreach (var keyField in KeyFields)
            {
                hashCode ^= keyField.GetHashCode();
            }

            if (hashCode == 0)
            {
                return base.GetHashCode();
            }

            return hashCode;
        }
    }
}
