namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation
{
    using System;
    using System.Collections.Generic;

    public class ContractAllocation
    {
        public ContractAllocation()
        {
            Amounts = new AmountSummary();
            ContractDeliverables = new List<ContractDeliverable>();
            Contract = new Contract();
        }

        public string ContractAllocationNumber { get; set; }

        public string FundingstreamPeriodCode { get; set; }

        public DateTime AllocationStartDate { get; set; }

        public DateTime AllocationEndDate { get; set; }

        public AmountSummary Amounts { get; set; }

        public IList<ContractDeliverable> ContractDeliverables { get; set; }

        public Contract Contract { get; set; }
    }
}