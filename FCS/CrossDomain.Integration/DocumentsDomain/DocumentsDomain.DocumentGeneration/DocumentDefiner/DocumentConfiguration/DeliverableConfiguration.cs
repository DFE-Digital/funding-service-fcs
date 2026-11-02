namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration
{
    public class DeliverableConfiguration
    {
        public static readonly DeliverableConfiguration NullConfiguration = new DeliverableConfiguration(0, false, false, 0, false, string.Empty, new int[0]);

        public DeliverableConfiguration()
        {
        }
    
        public DeliverableConfiguration(
            int deliverableCode,
            bool includeOnFundingAgreement,
            bool isMandatoryOnFundingAgreement,
            int displayOrder,
            bool allowCustomDescription,
            string displayName,
            int[] displayValueIsAggregate)
        {
            DeliverableCode = deliverableCode;
            IncludeOnFundingAgreement = includeOnFundingAgreement;
            IsMandatoryOnFundingAgreement = isMandatoryOnFundingAgreement;
            DisplayOrder = displayOrder;
            AllowCustomDescription = allowCustomDescription;
            DisplayName = displayName;
            DisplayValueIsAggregate = displayValueIsAggregate;
        }

        public int DeliverableCode { get; set; }

        public bool IncludeOnFundingAgreement { get; set; }

        public bool IsMandatoryOnFundingAgreement { get; set; }

        public int DisplayOrder { get; set; }

        public bool AllowCustomDescription { get; set; }

        public string DisplayName { get; set; }

        public int[] DisplayValueIsAggregate { get; set; }

        public bool ShouldDisplayValue { get; set; }

        public bool ShouldDisplayVolume { get; set; }

        public bool ShouldDisplayUnitCost { get; set; }
    }
}
