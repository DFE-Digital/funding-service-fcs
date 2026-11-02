namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;

    [ExcludeFromCodeCoverage]
    public class CrmLookupEntityDetail
    {
        public CrmLookupEntityDetail(string entityName, string lookupColumn)
        {
            EntityName = entityName;
            LookupColumn = lookupColumn;
        }

        public CrmLookupEntityDetail(string entityName, IEnumerable<string> lookupColumns)
        {
            EntityName = entityName;
            LookupColumns = lookupColumns;
        }

        public string EntityName { get; private set; }

        public string LookupColumn { get; private set; }

        public IEnumerable<string> LookupColumns { get; private set; }
    }
}
