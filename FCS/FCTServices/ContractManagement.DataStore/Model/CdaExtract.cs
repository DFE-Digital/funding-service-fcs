namespace ContractManagement.DataStore.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class CdaExtract
    {
        public CdaExtract(string extractName)
        {
            ExtractName = extractName;
        }

        private CdaExtract()
        {
        }

        [Key]
        [Column(Order = 1)]
        [MaxLength(100)]
        public string ExtractName { get; private set; }

        public DateTime? ReportingCloseDate { get; set; }

        public bool ArchiveClosedContracts { get; set; }

        public virtual ICollection<CdaReportFundingStreamPeriod> CdaReportFundingStreamPeriods { get; set; }
    }
}