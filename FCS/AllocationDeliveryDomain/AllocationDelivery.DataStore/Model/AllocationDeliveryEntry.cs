namespace SFA.FCT.AllocationDelivery.DataStore.Model
{
    using System.ComponentModel.DataAnnotations.Schema;
    using CrossDomain.Integration.Entities;
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Globalization;
    using Extensions;

    public class AllocationDeliveryEntry
    {
        [Key]
        public int ID { get; set; }

        public Guid Identifier { get; set; }

        public AllocationDeliveryEntryCategory AllocationDeliveryCategory { get; set; }

        [Index("IX_AllocationDeliveryEntry_AllocationNumber")]
        [MaxLength(20)]
        [Required]
        public string AllocationNumber { get; set; }

        [Required]
        public int? VersionNumber { get; set; }

        [Required]
        public int? SubVersionNumber { get; set; }

        [MaxLength(20)]
        [Required]
        public string ContractNumber { get; set; }

        [MaxLength(10)]
        [Required]
        public string SchemaVersion { get; set; }

        [Required, DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public DateTime CreatedDate { get; set; }

        /// <summary>
        /// This holds the Allocation Delivery Performance xml zipped into bytes
        /// </summary>
        public byte[] CorporateAllocationDeliveryBytes { get; set; }

        public virtual AllocationDeliveryEntryData AllocationDeliveryEntryData { get; set; }

        public string GetAllocationDeliveryPerformanceXml()
        {
           return ZipHelper.ToStringFromZippedBytes(CorporateAllocationDeliveryBytes ?? AllocationDeliveryEntryData.CorporateAllocationDeliveryBytes); 
        }

        public static AllocationDeliveryEntry Create(AllocationDeliveryPerformance allocationDeliveryPerformance, AllocationDeliveryEntryCategory category)
        {
            AllocationDeliveryEntry allocationDeliveryEntry = new AllocationDeliveryEntry();
            allocationDeliveryEntry.SetAllocationDeliveryPerformance(allocationDeliveryPerformance, allocationDeliveryEntry);
            allocationDeliveryEntry.Identifier = Guid.NewGuid();
            allocationDeliveryEntry.AllocationNumber = allocationDeliveryPerformance.contractAllocationNumber;
            allocationDeliveryEntry.VersionNumber = allocationDeliveryPerformance.Contract.contractVersionNumber;
            allocationDeliveryEntry.SubVersionNumber = allocationDeliveryPerformance.Contract.contractSubVersionNumber;
            allocationDeliveryEntry.ContractNumber = allocationDeliveryPerformance.Contract.contractNumber;
            allocationDeliveryEntry.SchemaVersion = allocationDeliveryPerformance.schemaVersion.ToString(CultureInfo.InvariantCulture);
            allocationDeliveryEntry.AllocationDeliveryCategory = category;

            return allocationDeliveryEntry;
        }

        private void SetAllocationDeliveryPerformance(AllocationDeliveryPerformance allocationDeliveryPerformance, AllocationDeliveryEntry allocationDeliveryEntry)
        {
            AllocationDeliveryEntryData = new AllocationDeliveryEntryData
            {
                CorporateAllocationDeliveryBytes =
                    ZipHelper.ToZippedBytesFromString(allocationDeliveryPerformance.SerializeToXml()),
                AllocationDeliveryEntry = allocationDeliveryEntry
            };
        }
    }
}