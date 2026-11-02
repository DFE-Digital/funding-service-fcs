namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Implementation.Entities;
    using MoreLinq;

    public class LookupWithColumnFilterKey
    {
        public LookupWithColumnFilterKey(CrmLookupType lookupType, string columnName, IEnumerable<string> columnFilterValues)
        {
            LookupType = lookupType;
            ColumnName = columnName;
            ColumnFilterValues = columnFilterValues;
            if (ColumnName == null || columnFilterValues == null)
            {
                throw new ArgumentException(string.Format("All values must be non null when constructing {0}", GetType()));
            }
        }

        public CrmLookupType LookupType { get; private set; }

        /// <summary>
        /// Gets the column name that we want to return
        /// </summary>
        public string ColumnName { get; private set; }

        public IEnumerable<string> ColumnFilterValues { get; private set; }

        public override bool Equals(object obj)
        {
            LookupWithColumnFilterKey comparisonObject = obj as LookupWithColumnFilterKey;
            bool isEqual = false;

            if (comparisonObject != null)
            {
                isEqual = LookupType.Equals(comparisonObject.LookupType) &&
                          ColumnName.Equals(comparisonObject.ColumnName) &&
                          ColumnFilterValues.SequenceEqual(comparisonObject.ColumnFilterValues);
            }

            return isEqual;
        }

        public override int GetHashCode()
        {
            int hashCode = 0;
            ColumnFilterValues.ForEach(v => hashCode ^= v.GetHashCode());
            hashCode ^= LookupType.GetHashCode() ^ ColumnName.GetHashCode();

            return hashCode;
        }
    }
}