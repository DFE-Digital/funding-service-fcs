namespace ContractManagement.DataStore.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public class ApprovedContract
    {
        private ApprovedContract()
        {
        }

        public ApprovedContract(
            string contractNumber,
            int contractVersionNumber,
            int contractSubVersionNumber,
            string fundingType,
            string fundingPeriod,
            int ukprn,
            string organisationId, string masterContractNumber,
            DateTime startDate, DateTime? endDate)
        {
            ContractNumber = contractNumber;
            ContractVersionNumber = contractVersionNumber;
            ContractSubVersionNumber = contractSubVersionNumber;
            FundingType = fundingType;
            FundingPeriod = fundingPeriod;
            Ukprn = ukprn;
            OrganisationId = organisationId;
            MasterContractNumber = masterContractNumber;
            StartDate = startDate;
            EndDate = endDate;
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ApprovedContractId { get; private set; }

        [StringLength(50)]
        [Index("IX_ApprovedContractNumberContractVersionContractSubversion", 1, IsUnique = true)]

        public string ContractNumber { get; private set; }

        [Index("IX_ApprovedContractNumberContractVersionContractSubversion", 2, IsUnique = true)]
        public int ContractVersionNumber { get; private set; }

        [Index("IX_ApprovedContractNumberContractVersionContractSubversion", 3, IsUnique = true)]
        public int ContractSubVersionNumber { get; private set; }

        public virtual ICollection<ApprovedContractAllocation> ApprovedContractAllocations { get; set; }

        [ForeignKey("FundingTypeFundingPeriod"), Column(Order = 1)]
        [MaxLength(100)]
        public string FundingType { get; private set; }

        [ForeignKey("FundingTypeFundingPeriod"), Column(Order = 2)]
        [MaxLength(100)]
        public string FundingPeriod { get; private set; }

        [Index("IX_ApprovedContractUkprn", IsUnique = false)]
        public int Ukprn { get; private set; }

        [Required]
        [StringLength(10)]
        public string OrganisationId { get; private set; }

        public FundingTypeFundingPeriod FundingTypeFundingPeriod { get; set; }

        [Index("IX_ApprovedContractMasterContract", IsUnique = false)]
        [MaxLength(50)]
        public string MasterContractNumber { get; private set; }

        public DateTime? StartDate { get; private set; }

        public DateTime? EndDate { get; private set; }

        public ApprovedContractAllocation GetAllocationByNumber(string allocationNumber)
        {
            return ApprovedContractAllocations.Single(a => a.ContractAllocationNumber == allocationNumber);
        }
    }
}