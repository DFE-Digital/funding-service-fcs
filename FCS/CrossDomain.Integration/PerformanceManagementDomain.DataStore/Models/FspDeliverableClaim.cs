namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FspDeliverableClaim
    {
        private FspDeliverableClaim()
        {
        }

        public FspDeliverableClaim(
            string fspCode,
            int deliverableCode,
            string deliverableName,
            bool allowClaim,
            string claimReconciliationDeliverableGroupCode)
        {
            FspCode = fspCode;
            DeliverableCode = deliverableCode;
            DeliverableName = deliverableName;
            AllowClaim = allowClaim;
            ClaimReconciliationDeliverableGroupCode = claimReconciliationDeliverableGroupCode;
        }

        [Key, Column(Order = 0)]
        [MaxLength(30)]
        public string FspCode { get; private set; }

        [Key, Column(Order = 1)]
        public int DeliverableCode { get; private set; }

        [Required, MaxLength(120)]
        public string DeliverableName { get; private set;  }

        [Required]
        public bool AllowClaim { get; set; }

        [MaxLength(30)]
        public string ClaimReconciliationDeliverableGroupCode { get; set; }

        public int? ParentDeliverableCode { get; set; }

        [Required]
        public bool AllowProfile { get; set; }

        public ClaimReconciliationDeliverableGroup ClaimReconciliationDeliverableGroup { get; set; }
    }
}
