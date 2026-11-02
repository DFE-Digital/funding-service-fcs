namespace SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Utils
{
    using System.Collections.Generic;

    public class CrmLookupCriteria
    {
        public string EntityName { get; set; }

        public List<ColumnValueCriteria> LookupCriteria { get; set; }

    }
}
