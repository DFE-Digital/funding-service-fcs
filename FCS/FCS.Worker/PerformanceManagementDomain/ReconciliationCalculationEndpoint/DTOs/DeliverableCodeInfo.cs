namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs
{
    public class DeliverableCodeInfo
    {
        public DeliverableCodeInfo(int deliverableCode, int? parentDeliverableCode, string claimReconciliationDeliverableGroupCode = null, bool allowProfile = true)
        {
            DeliverableCode = deliverableCode;
            ParentDeliverableCode = parentDeliverableCode;
            ClaimReconciliationDeliverableGroupCode = claimReconciliationDeliverableGroupCode;
            AllowProfile = allowProfile;
        }

        public int DeliverableCode { get; }
        public int? ParentDeliverableCode { get; }
        public bool AllowProfile { get; set; }

        public string ClaimReconciliationDeliverableGroupCode { get; }
    }
}
