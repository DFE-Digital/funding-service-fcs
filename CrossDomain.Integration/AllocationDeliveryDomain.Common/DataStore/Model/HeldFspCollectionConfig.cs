namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class HeldFspCollectionConfig
    {
        private HeldFspCollectionConfig()
        {
        }

        public HeldFspCollectionConfig(int multipleCollectionGroupId, string fundingStreamPeriodCode,
            string collectionType, string collectionReturnCode)
        {
            MultipleCollectionGroupId = multipleCollectionGroupId;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            CollectionType = collectionType;
            CollectionReturnCode = collectionReturnCode;
        }

        [Key]
        [Column(Order = 1)]
        public int MultipleCollectionGroupId { get; private set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(20)]
        [Index("IX_HeldFspCollectionConfig_Unique", Order = 1, IsUnique = true)]
        public string FundingStreamPeriodCode { get; private set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(20)]
        [Index("IX_HeldFspCollectionConfig_Unique", Order = 2, IsUnique = true)]
        public string CollectionType { get; private set; }

        [StringLength(10)]
        [Required]
        [Index("IX_HeldFspCollectionConfig_Unique", Order = 3, IsUnique = true)]
        public string CollectionReturnCode { get; private set; }
    }
}