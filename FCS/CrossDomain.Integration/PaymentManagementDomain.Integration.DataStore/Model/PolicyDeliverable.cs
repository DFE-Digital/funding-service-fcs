namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    /// <summary>
    /// Entity representing a Policy Deliverable
    /// </summary>
    public class PolicyDeliverable
    {
        [Key, Column(Order = 0)]
        [Index("IX_DeliverableIndex", 1, IsUnique = true)]
        public int DeliverableCode { get; set; }

        [Key, Column(Order = 1)]
        [Index("IX_DeliverableIndex", 2, IsUnique = true)]
        [Index("IX_PolicyDeliverable_FundingStreamPeriod", Order = 1, IsUnique = false)]
        public string FundingStreamPeriod { get; set; }

        public bool IsPayable { get; set; }

        public ICollection<PolicyDeliverableToSubnominals> PolicyDeliverablesToSubnominals { get; set; }

        public int? FundingStreamPeriodCappingGroupId { get; set; }
        
        public int? ParentDeliverableCode { get; set; }

        public int? CappingApportionmentPriorityOrder { get; set; }

        [Required]
        public bool AllowProfile { get; set; }
    }
}
