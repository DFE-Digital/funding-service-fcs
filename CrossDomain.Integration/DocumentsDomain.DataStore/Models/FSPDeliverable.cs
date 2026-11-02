namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FSPDeliverable
    {
        public FSPDeliverable(int deliverableCode, string fundingStreamPeriodCode, bool allowProfile,
            bool displayOnFundingAgreement, bool mandatoryOnFundingAgreement,
            int displayOrderOnFundingAgreement, bool allowCustomDescription,
            bool shouldDisplayValue, bool shouldDisplayVolumeAndUnitCost,
            string displayNameOnSummaryOfFunding, string displayNameOnFundingAgreement,
            bool displayOnSummaryOfFunding)
        {
            DeliverableCode = deliverableCode;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            AllowProfile = allowProfile;
            DisplayOnFundingAgreement = displayOnFundingAgreement;
            MandatoryOnFundingAgreement = mandatoryOnFundingAgreement;
            DisplayOrderOnFundingAgreement = displayOrderOnFundingAgreement;
            AllowCustomDescription = allowCustomDescription;
            ShouldDisplayValue = shouldDisplayValue;
            ShouldDisplayVolumeAndUnitCost = shouldDisplayVolumeAndUnitCost;
            DisplayNameOnSummaryOfFunding = displayNameOnSummaryOfFunding;
            DisplayNameOnFundingAgreement = displayNameOnFundingAgreement;
            DisplayOnSummaryOfFunding = displayOnSummaryOfFunding;
        }

        // for Entity Framework to call
        private FSPDeliverable()
        {
        }

        [Key, Column(Order = 0)]
        public int DeliverableCode { get; private set; }

        [Key, Column(Order = 1)]
        [MaxLength(100)]
        public string FundingStreamPeriodCode { get; private set; }

        [Required]
        public bool AllowProfile { get; set; }

        public bool DisplayOnFundingAgreement { get; set; }

        public bool MandatoryOnFundingAgreement { get; set; }

        public int DisplayOrderOnFundingAgreement { get; set; }

        public bool AllowCustomDescription { get; set; }

        public bool ShouldDisplayValue { get; set; }

        public bool ShouldDisplayVolumeAndUnitCost { get; set; }

        [MaxLength(150)]
        public string DisplayNameOnSummaryOfFunding { get; set; }

        [MaxLength(150)]
        public string DisplayNameOnFundingAgreement { get; set; }

        public bool DisplayOnSummaryOfFunding { get; set; }

        public virtual FundingStreamPeriod FundingStreamPeriod { get; set; }
    }
}