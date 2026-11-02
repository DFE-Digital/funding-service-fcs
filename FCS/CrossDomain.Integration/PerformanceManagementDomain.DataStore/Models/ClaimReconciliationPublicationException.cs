namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ClaimReconciliationPublicationException
    {
        private ClaimReconciliationPublicationException()
        {
        }

        public ClaimReconciliationPublicationException(string claimReconciliationAllocationGroupCode, int ukprn)
        {
            ClaimReconciliationAllocationGroupCode = claimReconciliationAllocationGroupCode;
            Ukprn = ukprn;
        }

        [Key, Column(Order = 1)]
        [MaxLength(30)]
        public string ClaimReconciliationAllocationGroupCode { get; private set; }

        [Key, Column(Order = 2)]
        public int Ukprn  { get; private set; }

        public ClaimReconciliationAllocationGroup ClaimReconciliationAllocationGroup { get; set; }
    }
}
