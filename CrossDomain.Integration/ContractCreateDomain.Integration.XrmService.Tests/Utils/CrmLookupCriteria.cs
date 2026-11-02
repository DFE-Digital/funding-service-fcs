namespace ContractCreateDomain.Integration.XrmService.Tests.Utils
{
    using System.Collections.Generic;
    public class CrmLookupCriteria
    {
        public string EntityName { get; set; }

        public List<ColumnValueCriteria> LookupCriteria { get; set; }

    }
}
