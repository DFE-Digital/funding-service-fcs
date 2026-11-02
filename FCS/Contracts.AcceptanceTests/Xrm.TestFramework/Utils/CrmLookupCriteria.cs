namespace SFA.FCT.Xrm.TestFramework.Utils
{
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk.Query;

    public class CrmLookupCriteria
    {
        public CrmLookupCriteria()
        {
            LinkEntities = new List<LinkEntity>();
        }

        public string EntityName { get; set; }
        
        public RelationshipDetail RelationshipDetail { get; set; }
        
        public IList<ColumnValueCriteria> LookupCriteria { get; set; }
        
        public IList<LinkEntity> LinkEntities { get; set; }
    }
}