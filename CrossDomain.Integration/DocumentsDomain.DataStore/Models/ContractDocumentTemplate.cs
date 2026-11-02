namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ContractDocumentTemplate
    {
        public ContractDocumentTemplate(
            string fundingTypeCode,
            string fundingPeriodCode,
            string documentComponentCode,
            string contractType,
            string template)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            DocumentComponentCode = documentComponentCode;
            ContractType = contractType;
            Template = template;
        }

        private ContractDocumentTemplate()
        { }

        [Key, Column(Order = 1), MaxLength(100)]
        public string FundingTypeCode { get; private set; }

        [Key, Column(Order = 2), MaxLength(100)]
        public string FundingPeriodCode { get; private set; }

        [Key, Column(Order = 3), MaxLength(100)]
        public string DocumentComponentCode { get; private set; }

        [Key, Column(Order = 4), MaxLength(100) ]
        public string ContractType { get; private set; }

        [MaxLength(100), Required]
        public string Template { get; set; }
    }
}
