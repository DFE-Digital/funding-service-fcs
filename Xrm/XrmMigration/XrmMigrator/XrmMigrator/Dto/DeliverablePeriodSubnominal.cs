namespace XrmMigrator.Dto
{
    public class DeliverablePeriodSubnominal
    {
        public string AllocationNumber { get; set; }

        public string DeliverableCode { get; set; }

        public string Period { get; set; }

        public SubnominalType SubnominalType { get; set; }

        public string SubnominalCode { get; set; }

    }

    public enum SubnominalType
    {
        Reconcilation,
        Capping,
        Profile
    }
}
