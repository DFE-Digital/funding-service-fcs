namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class AtomFeedItem
    {
        private AtomFeedItem()
        {
        }

        public AtomFeedItem(AtomItemType atomItemType, int ukPrn, string claimTypeName, string allocationGroupName, string period, string atomFeedItemXml)
        {
            ItemType = atomItemType;
            Ukprn = ukPrn;
            ClaimTypeName = claimTypeName;
            AllocationGroupName = allocationGroupName;
            Period = period;
            AtomFeedItemXml = atomFeedItemXml;
            CreatedDate = DateTime.UtcNow;
        }

        public AtomFeedItem(AtomItemType atomItemType, int ukPrn, string claimTypeName, string allocationGroupName, string period, string atomFeedItemXml, DateTime createdDate) :
            this(atomItemType, ukPrn, claimTypeName, allocationGroupName, period, atomFeedItemXml)
        {
            CreatedDate = createdDate;
        }

        [Key]
        public int Id { get; set; }

        [Required]
        public Guid Identifier { get; private set; } = Guid.NewGuid();

        [Required]
        public AtomItemType ItemType { get; set; }

        [Index("IX_AtomFeedNaturalKey", 1, IsUnique = true)]
        [Required]
        public int Ukprn { get; set; }

        [Index("IX_AtomFeedNaturalKey", 2, IsUnique = true)]
        [MaxLength(50)]
        [Required]
        public string ClaimTypeName { get; set; }

        [Index("IX_AtomFeedNaturalKey", 3, IsUnique = true)]
        [MaxLength(100)]
        [Required]
        public string AllocationGroupName { get; set; }

        [Index("IX_AtomFeedNaturalKey", 4, IsUnique = true)]
        [MaxLength(4)]
        [Required]
        public string Period { get; set; }

        [Column(TypeName = "xml")]
        [Required]
        public string AtomFeedItemXml { get; set; }

        [Required]
        public DateTime CreatedDate { get; private set; }
    }
}
