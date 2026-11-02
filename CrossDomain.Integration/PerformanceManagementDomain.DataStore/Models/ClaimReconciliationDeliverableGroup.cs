namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;

    public class ClaimReconciliationDeliverableGroup
    {
        private ClaimReconciliationDeliverableGroup()
        {
        }

        public ClaimReconciliationDeliverableGroup(string claimReconciliationDeliverableGroupCode, string claimReconciliationDeliverableGroupName, bool capClaimToProfile, bool obtainProfileFromReferenceData)
        {
            ClaimReconciliationDeliverableGroupCode = claimReconciliationDeliverableGroupCode;
            ClaimReconciliationDeliverableGroupName = claimReconciliationDeliverableGroupName;
            CapClaimToProfile = capClaimToProfile;
            ObtainProfileFromReferenceData = obtainProfileFromReferenceData;
        }

        [Key]
        [MaxLength(30)]
        public string ClaimReconciliationDeliverableGroupCode { get; private set; }

        [MaxLength(100)]
        public string ClaimReconciliationDeliverableGroupName { get; set; }

        [Required]
        public bool CapClaimToProfile { get; set; }

        [Required]
        public bool ObtainProfileFromReferenceData { get; set; }
    }
}
