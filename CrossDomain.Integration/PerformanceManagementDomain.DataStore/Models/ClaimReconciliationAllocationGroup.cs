namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;

    public class ClaimReconciliationAllocationGroup
    {
        private ClaimReconciliationAllocationGroup()
        {
        }

        public ClaimReconciliationAllocationGroup(string claimReconciliationAllocationGroupCode, string groupName)
        {
            ClaimReconciliationAllocationGroupCode = claimReconciliationAllocationGroupCode;
            GroupName = groupName;
        }

        [Key]
        [MaxLength(30)]
        public string ClaimReconciliationAllocationGroupCode { get; private set; }

        [MaxLength(100)]
        public string GroupName { get; set; }
    }
}
