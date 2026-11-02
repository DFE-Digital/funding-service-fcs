namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ClaimReconciliationReferenceDataProfile
    {
        private ClaimReconciliationReferenceDataProfile()
        {
        }

        public ClaimReconciliationReferenceDataProfile(string claimReconciliationDeliverableGroupCode, int ukprn, decimal plannedValue)
        {
            ClaimReconciliationDeliverableGroupCode = claimReconciliationDeliverableGroupCode;
            Ukprn = ukprn;
            PlannedValue = plannedValue;
        }

        [Key, Column(Order = 0)]
        [MaxLength(30)]
        public string ClaimReconciliationDeliverableGroupCode { get; private set; }

        [Key, Column(Order = 1)]
        public int Ukprn { get; private set; }

        [Required]
        public decimal PlannedValue { get; set; }
    }
}
