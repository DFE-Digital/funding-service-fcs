namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.ProcessedMessage")]
    public partial class ProcessedMessage
    {
        [Key]
        public string MessageId { get; set; }

        [Required]
        [StringLength(50)]
        public string Endpoint { get; set; }

        [Required]
        [StringLength(100)]
        public string MessageType { get; set; }

        [Required]
        [StringLength(200)]
        public string BusinessKey { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }
    }
}
