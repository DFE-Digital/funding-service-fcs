namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ClaimReconciliationAllocationGroupFsp
    {
        private ClaimReconciliationAllocationGroupFsp()
        {
        }

        public ClaimReconciliationAllocationGroupFsp(string claimReconciliationAllocationGroupCode, string fspCode)
        {
            ClaimReconciliationAllocationGroupCode = claimReconciliationAllocationGroupCode;
            FspCode = fspCode;
        }

        [Key, Column(Order = 0)]
        [MaxLength(30)]
        public string FspCode { get; private set; }

        [MaxLength(30)]
        public string ClaimReconciliationAllocationGroupCode { get; private set; }

        public ClaimReconciliationAllocationGroup ClaimReconciliationAllocationGroup { get; set; }
    }
}
