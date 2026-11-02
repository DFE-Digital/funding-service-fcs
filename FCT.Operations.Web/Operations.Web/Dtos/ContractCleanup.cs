using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Operations.Web.Dtos
{
    public class ContractCleanup
    {
        public string FundingId { get; set; }
        public string ContractNumber { get; set; }
        public int? ContractVersionNumber { get; set; }
        public int? ContractSubVersionNumber { get; set; }
        public int UKPRN { get; set; }
        public Guid CrmEntityId { get; set; }
        public string AllocationFundingStream { get; set; }
        public string ReleaseGroupName { get; set; }
        public string ReleaseStatus { get; set; }

    }
}