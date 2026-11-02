namespace ContractManagementService.DTOs
{
    using System;
    using System.ComponentModel;
    using Infrastructure;

    public class AllocationDeliveryEntry
    {
        public int ID { get; set; }

        public Guid Identifier { get; set; }

        public AllocationDeliveryEntryCategory AllocationDeliveryCategory { get; set; }

        public string AllocationNumber { get; set; }

        public int? VersionNumber { get; set; }

        public int? SubVersionNumber { get; set; }

        public string ContractNumber { get; set; }

        public string SchemaVersion { get; set; }

        public DateTime CreatedDate { get; set; }

        /// <summary>
        /// This holds the Allocation Delivery Performance xml zipped into bytes
        /// </summary>
        public byte[] CorporateAllocationDeliveryBytes { get; set; }

        public string GetAllocationDeliveryPerformanceXml()
        {
            return ZipHelper.ToStringFromZippedBytes(CorporateAllocationDeliveryBytes);
        }
    }

    public enum AllocationDeliveryEntryCategory
    {
        [Description("New Contract Allocation Approved")]
        NewContractAllocationApproved,
        [Description("Amended Contract Allocation Approved")]
        AmendedContractAllocationApproved,
        [Description("Contract Allocation Actuals Received")]
        ContractAllocationActualsReceived,
        [Description("Contract Allocation Payment Posted")]
        ContractAllocationPaymentReceived,
        [Description("Contract Allocation Actuals Updated")]
        ContractAllocationActualsUpdated
    }
}
