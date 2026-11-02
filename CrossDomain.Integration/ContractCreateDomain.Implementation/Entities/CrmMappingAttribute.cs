namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System;
    using System.Diagnostics.CodeAnalysis;

    [ExcludeFromCodeCoverage]
    public class CrmMappingAttribute : Attribute
    {
        public CrmMappingAttribute(string columnName)
        {
            LookupType = CrmLookupType.NotSet;
            CrmColumnName = columnName;
            ColumnType = CrmColumnType.NotSet;
        }

        public CrmMappingAttribute(string columnName, CrmOptionSetType optionSetType)
        {
            LookupType = CrmLookupType.NotSet;
            OptionSetType = optionSetType;
            CrmColumnName = columnName;
        }

        public CrmMappingAttribute(string columnName, CrmColumnType type)
            : this(columnName)
        {
            ColumnType = type;
        }

        public CrmMappingAttribute(string columnName, CrmLookupType lookupType)
            : this(columnName, CrmColumnType.Text)
        {
            LookupType = lookupType;
        }

        public CrmMappingAttribute(string columnName, CrmColumnType columnType, CrmLookupType lookupType)
            : this(columnName, columnType)
        {
            LookupType = lookupType;
        }

        public string CrmColumnName { get; private set; }

        public CrmColumnType ColumnType { get; private set; }

        public CrmLookupType LookupType { get; private set; }

        public CrmOptionSetType OptionSetType { get; private set; }
    }
}
