namespace ContractManagement.DataStore.Model
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ApprovedContractAllocation
    {
        [Key, Column(Order = 0)]
        [StringLength(50)]
        public string ContractAllocationNumber { get; set; }

        [Key, Column(Order = 1)]
        public int ApprovedContractId { get; set; }

        public bool? HasOutstandingPayments { get; set; }

        public int? DeliveryOrganisationUkprn { get; set; }

        [StringLength(10)]
        public string DeliveryOrganisationId { get; set; }

        public decimal TotalPlannedValue { get; set; }

        public decimal? PlannedValueEnvelope1 { get; set; }

        public decimal? PlannedValueEnvelope2 { get; set; }

        [MaxLength(100)]
        [Index("IX_ApprovedContractAllocationFsp", IsUnique = false)]
        public string FundingStreamPeriodCode { get; set; }

        [ForeignKey("ApprovedContractId")]
        public virtual ApprovedContract ApprovedContract { get; set; }

        public virtual ICollection<ApprovedContractDeliverable> ApprovedContractDeliverables { get; set; }

        public bool HasDeliveryOrg()
        {
            return !string.IsNullOrEmpty(DeliveryOrganisationId)
                   && DeliveryOrganisationUkprn != null;
        }
    }
}