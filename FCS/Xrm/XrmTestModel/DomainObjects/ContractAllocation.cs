namespace XrmTestModel
{
    using System;
    using System.Collections.Generic;
    using DomainObjects;

    public class ContractAllocation
    {
        public string ContractAllocationRef { get; set; }
        
        public DateTime? StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        public virtual Contract Contract { get; set; }

        public decimal AllocationValue { get; set; }

        public string FundingStream { get; set; }

        public virtual FundingStreamPeriod FundingStreamPeriod { get; set; }

        public virtual IEnumerable<ContractDeliverable> Deliverables { get; set; }
    }
}