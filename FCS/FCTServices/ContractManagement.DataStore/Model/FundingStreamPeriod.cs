namespace ContractManagement.DataStore.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public class FundingStreamPeriod
    {
        private FundingStreamPeriod()
        {
        }

        public FundingStreamPeriod(string fundingStreamPeriodCode, DateTime startDate)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            StartDate = startDate;
        }

        [Key, MaxLength(100)]
        public string FundingStreamPeriodCode { get; private set; }

        [Required]
        public DateTime StartDate { get; set; }

        public virtual ICollection<FundingStreamPeriodLegalDeliverable> LegalDeliverables { get; set; }
    }
}
