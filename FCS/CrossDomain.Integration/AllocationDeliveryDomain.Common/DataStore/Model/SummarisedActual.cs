namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public class SummarisedActual
    {
        private static readonly IReadOnlyCollection<string> SkillsBootcampFsps = new List<string>
        {
            "SB2022",
            "SB-PAA2022"
        };

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Index("IX_SummarisedActual_Natural_Key", Order = 1, IsUnique = true)]
        [Index("IX_SummarisedActual_Actuals_Group", Order = 1, IsUnique = false)]
        [Required]
        [StringLength(20)]
        public string CollectionType { get; set; }

        [Index("IX_SummarisedActual_Natural_Key", Order = 2, IsUnique = true)]
        [Index("IX_SummarisedActual_Actuals_Group", Order = 2, IsUnique = false)]
        [Required]
        [StringLength(20)]
        public string CollectionReturnCode { get; set; }

        [Index("IX_SummarisedActual_Natural_Key", Order = 3, IsUnique = true)]
        [Index("IX_SummarisedActual_Actuals_Group", Order = 3, IsUnique = false)]
        [Required]
        [StringLength(20)]
        public string OrganisationId { get; set; }

        [Index("IX_SummarisedActual_Natural_Key", Order = 4, IsUnique = true)]
        [Index("IX_SummarisedActual_Actuals_Group", Order = 4, IsUnique = false)]
        [Required]
        [StringLength(20)]
        public string FundingStreamPeriodCode { get; set; }

        [Index("IX_SummarisedActual_Natural_Key", Order = 5, IsUnique = true)]
        [Index("IX_SummarisedActual_Actuals_Group", Order = 5, IsUnique = false)]
        [StringLength(20)]
        public string UopCode { get; set; }

        [Index("IX_SummarisedActual_Natural_Key", Order = 6, IsUnique = true)]
        [StringLength(20)]
        public string ContractAllocationNumber { get; set; }

        [Index("IX_SummarisedActual_Natural_Key", Order = 7, IsUnique = true)]
        public int Period { get; set; }

        [Index("IX_SummarisedActual_Natural_Key", Order = 8, IsUnique = true)]
        public int DeliverableCode { get; set; }

        public int? ActualVolume { get; set; }

        public decimal ActualValue { get; set; }

        public int? DataCollectionsId { get; set; }

        public ClosedCollection ClosedCollection { get; set; }

        public bool IsSkillsBootcamp()
        {
            return SkillsBootcampFsps.Contains(FundingStreamPeriodCode);
        }
    }
}
