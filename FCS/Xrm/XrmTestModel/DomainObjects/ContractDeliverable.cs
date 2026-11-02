namespace XrmTestModel
{
    using System.Collections.Generic;

    public class ContractDeliverable
    {
        public virtual Contract Contract { get; set; }

        public virtual ContractAllocation Allocation { get; set; }

        public virtual ContractDeliverable ParentDeliverable { get; set; }

        public string DeliverableCode { get; set; }

        public string DeliverableName { get; set; }

        public string ProfileDeliverable { get; set; }

        public decimal PlannedValue { get; set; }

        public int PlannedVolume { get; set; }

        public decimal ActualValue { get; set; }

        public int ActualVolume { get; set; }

        public string Period { get; set; }

        public virtual IEnumerable<ContractDeliverable> Deliverables { get; set; }

        public virtual IEnumerable<ContractDeliverablePeriod> Periods { get; set; }
    }

}
