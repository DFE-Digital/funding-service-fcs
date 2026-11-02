namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ClaimReconciliationReferenceDataReconProfiling
    {
        // Introduced for 'FCR 20/21: Optionally stagger recoveries (35219)'
        // It identifies UKPRN/FundingPeriods that will have recovery/clawback amount staggered over 4 payment periods
        private ClaimReconciliationReferenceDataReconProfiling()
        {}

        public ClaimReconciliationReferenceDataReconProfiling(string fundingPeriod, int ukprn)
        {
            FundingPeriod = fundingPeriod;
            Ukprn = ukprn;
        }

        [Key, Column(Order = 0)]
        [MaxLength(30)]
        public string FundingPeriod { get; private set; }

        [Key, Column(Order = 1)]
        public int Ukprn { get; private set; }
    }
}