namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FspGroupDocumentTemplate
    {
         public FspGroupDocumentTemplate(
             string fundingTypeCode,
             string fundingPeriodCode,
             string documentComponentCode, 
             string fspGroupCode,
             string contractType,
             string template)
         {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            DocumentComponentCode = documentComponentCode;
            FSPGroupCode = fspGroupCode;
            ContractType = contractType;
            Template = template;
         }

         private FspGroupDocumentTemplate()
         {
         }

         [Key, Column(Order = 1), MaxLength(100)]
         public string FundingTypeCode { get; private set; }

         [Key, Column(Order = 2), MaxLength(100)]
         public string FundingPeriodCode { get; private set; }

         [Key, Column(Order = 3), MaxLength(100)]
         public string DocumentComponentCode { get; private set; }

         [Key, Column(Order = 4), MaxLength(50)]
         public string FSPGroupCode { get; private set; }

         [Key, Column(Order = 5), MaxLength(100)]
         public string ContractType { get; private set; }

         [MaxLength(100), Required]
         public string Template { get; set; }

         [ForeignKey("FSPGroupCode")]
         public virtual FSPGroup FspGroup { get; set; }
    }
}