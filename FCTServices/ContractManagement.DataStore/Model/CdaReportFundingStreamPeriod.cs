namespace ContractManagement.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class CdaReportFundingStreamPeriod
    {
        public CdaReportFundingStreamPeriod(string extractName, string fspCode)
        {
            ExtractName = extractName;
            FundingStreamPeriodCode = fspCode;
        }

        private CdaReportFundingStreamPeriod()
        {
        }

        [Key]
        [Column(Order = 1)]
        [MaxLength(100)]
        public string ExtractName { get; private set; }

        [Key]
        [Column(Order = 2)]
        [MaxLength(100)]
        public string FundingStreamPeriodCode { get; private set; }

        public CdaExtract CdaExtract { get; set; }
    }
}