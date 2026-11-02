namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    
    /// <summary>
    /// Entity representing policy deliverable attributes. 
    /// </summary>
    public class PolicyDeliverableToSubnominals
    {
        // Deliverable Fields
        [Key, Column(Order = 0)]
        [Index("IX_DeliverableIndex", 1, IsUnique = false)]
        public int DeliverableCode { get; set; }

        [Key, Column(Order = 1)]
        [Index("IX_DeliverableIndex", 2, IsUnique = false)]
        public string FundingStreamPeriod { get; set; }

        public PolicyDeliverable PolicyDeliverable { get;  set; }

        // Subnominal Fields
        [Key, Column(Order = 2)]
        [Index("IX_PolicySubnominal", 1, IsUnique = false)]
        public int SubnominalCode { get; set; }

        [Key, Column(Order = 3)]
        [Index("IX_PolicySubnominal", 2, IsUnique = false)]
        public PaymentType PaymentType { get; set; }

        public PolicySubnominal PolicySubnominal { get; set; }
    }
}
