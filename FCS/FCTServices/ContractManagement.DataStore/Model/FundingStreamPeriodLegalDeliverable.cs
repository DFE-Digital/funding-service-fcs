namespace ContractManagement.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingStreamPeriodLegalDeliverable
    {
        private FundingStreamPeriodLegalDeliverable()
        {
        }

        public FundingStreamPeriodLegalDeliverable(string fundingStreamPeriodCode, int deliverableCode, bool allowProfile,
            string deliverableName, int displayOrder)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            DeliverableCode = deliverableCode;
            AllowProfile = allowProfile;
            DeliverableName = deliverableName;
            DisplayOrder = displayOrder;
        }

        [Key, MaxLength(100), Column(Order = 1)]
        public string FundingStreamPeriodCode { get; private set; }

        [Key, Column(Order = 2)]
        public int DeliverableCode { get; private set; }

        public bool AllowProfile { get; private set; }

        [StringLength(100)]
        public string DeliverableName { get; set; }

        public int DisplayOrder { get; set; }
    }
}
