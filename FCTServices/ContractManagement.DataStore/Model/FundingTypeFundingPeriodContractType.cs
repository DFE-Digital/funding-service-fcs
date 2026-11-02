namespace ContractManagement.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingTypeFundingPeriodContractType
    {
        public FundingTypeFundingPeriodContractType(string fundingTypeCode, string fundingPeriodCode, string contractType, string definedContractTermForProvider)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            ContractType = contractType;
            DefinedContractTermForProvider = definedContractTermForProvider;
        }

        private FundingTypeFundingPeriodContractType()
        {}

        [Key, Column(Order = 1)]
        [MaxLength(100)]
        public string FundingTypeCode { get; private set; }

        [Key, Column(Order = 2)]
        [MaxLength(100)]
        public string FundingPeriodCode { get; private set; }

        [Key, Column(Order = 3)]
        [MaxLength(100)]
        public string ContractType { get; private set; }

        [Required, MaxLength(100)]
        public string DefinedContractTermForProvider { get; private set; }
    }
}