namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto
{
    using System.Collections.Generic;

    public class ContractDeliverable
    {
        public int DeliverableCode { get; set; }

        public int? ParentDeliverableCode { get; set; }

        public List<ContractDeliverablePeriod> ContractDeliverablePeriods { get; set; }

        public bool IsPayable { get; set; }

        public int? CappingGroupId { get; set; }

        public int? CappingApportionmentPriorityOrder { get; set; }
    }
}
