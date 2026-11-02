namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class HeldReportedActualGroup
    {
        private HeldReportedActualGroup()
        {
        }

        public HeldReportedActualGroup(string partitionKey, string fundingStreamPeriodCode, string organisationIdentifier, 
            string uoPCode, string collectionType, string collectionReturnCode)
        {
            PartitionKey = partitionKey;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            OrganisationIdentifier = organisationIdentifier;
            UoPCode = uoPCode;
            CollectionType = collectionType;
            CollectionReturnCode = collectionReturnCode;
        }

        [Key]
        [StringLength(200)]
        public string PartitionKey { get; private set; }

        [StringLength(20)]
        [Required]
        [Index("IX_HeldReportedActualGroup_FundingStreamPeriodCodeOrganisationIdentifierUoPCode", Order = 1, IsUnique = false)]
        public string FundingStreamPeriodCode { get; private set; }

        [StringLength(10)]
        [Required]
        [Index("IX_HeldReportedActualGroup_FundingStreamPeriodCodeOrganisationIdentifierUoPCode", Order = 2, IsUnique = false)]
        public string OrganisationIdentifier { get; private set; }

        [StringLength(100)]
        [Index("IX_HeldReportedActualGroup_FundingStreamPeriodCodeOrganisationIdentifierUoPCode", Order = 3, IsUnique = false)]
        public string UoPCode { get; private set; }

        [StringLength(20)]
        [Required]
        public string CollectionType { get; private set; }

        [StringLength(10)]
        [Required]
        public string CollectionReturnCode { get; private set; }

        public DateTime? ProcessedDate { get; set; }
    }
}