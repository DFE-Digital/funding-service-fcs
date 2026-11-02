namespace Operations.Web.Dtos
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("PaymentGeneration.PaymentBatchFeedItem")]
    public partial class PaymentBatchFeedItem
    {
        public int Id { get; set; }

        public Guid Identifier { get; set; }

        [Required]
        [StringLength(20)]
        public string FundingStreamPeriod { get; set; }

        [Required]
        [StringLength(10)]
        public string PaymentPeriod { get; set; }

        public DateTime CensusEndDate { get; set; }

        public int PaymentLineCount { get; set; }

        [Required]
        [StringLength(2)]
        public string LinkCodeSuffix { get; set; }

        public byte[] CorporatePaymentBatchBytes { get; set; }

        public DateTime CreatedDate { get; set; }

        public decimal TotalValue { get; set; }
    }
}
