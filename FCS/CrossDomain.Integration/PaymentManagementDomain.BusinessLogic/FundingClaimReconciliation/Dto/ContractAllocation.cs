namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto
{
    using System;
    using System.Collections.Generic;

    public class ContractAllocation
    {
        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public FundingStreamPeriod FundingStreamPeriod { get; set; }

        public string AllocationNumber { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public decimal ClaimReconciliationValue { get; set; }

        public List<ContractDeliverable> ContractDeliverables { get; set; }
    }
}
