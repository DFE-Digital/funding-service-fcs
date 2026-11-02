namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration
{
    using System.Xml.Serialization;
    using Microsoft.SqlServer.Server;

    public class DocumentConfiguration
    {
        public FundingStreamConfig FundingStreamConfig { get; set; }
    }

    public class FundingStreamConfig
    {
        public DeliverableConfigurationForFundingAgreement DeliverableConfigurationForFundingAgreement { get; set; }

        [XmlArray("AllocationSettingsForSummaryOfFunding")]
        public AllocationSettingForSummaryOfFunding[] AllocationSettingsForSummaryOfFunding { get; set; }

        [XmlArray("FundingAgreementDocuments")]
        public FundingAgreementDocument[] FundingAgreementDocuments { get; set; }

        [XmlArray("DeliverableConfigurationForSummaryOfFunding")]
        public SoFDeliverableConfiguration[] DeliverableConfigurationForSummaryOfFunding { get; set; }
    }

    public class SoFDeliverableConfiguration
    {
        public string FundingStreamPeriod { get; set; }

        public SoFDeliverable[] SoFDeliverables { get; set; }
    }

    public class SoFDeliverable
    {
        public int DeliverableCode { get; set; }

        public string DeliverableDescription { get; set; }
    }

    public class AllocationSettingForSummaryOfFunding
    {
        public string FundingStreamPeriod { get; set; }

        public int DisplayOrder { get; set; }
        
        public string Description { get; set; }
    }

    public class FundingAgreementDocument
    {
        public string FundingStreamPeriodCode { get; set; }

        public string DocumentTitle { get; set; }
        
        public string Template { get; set; }
        
        public string ExtraPagesTemplate { get; set; }
    }

    public class DeliverableConfigurationForFundingAgreement
    {
        [XmlArray("FundingStreamPeriods")]
        public FundingStreamPeriod[] FundingStreamPeriods { get; set; }
    }

    public class FundingStreamPeriod
    {
        public string FundingStreamPeriodCode { get; set; }

        [XmlArray("Deliverables")]
        public DeliverableConfigurationFile[] Deliverables { get; set; }
    }

    [XmlType("Deliverable")]
    public class DeliverableConfigurationFile
    {
        public int DeliverableCode { get; set; }

        public string IncludeOnFundingAgreement { get; set; }

        public string IsMandatoryOnFundingAgreement { get; set; }

        public int DisplayOrder { get; set; }

        public string AllowCustomDescription { get; set; }

        public string DisplayName { get; set; }

        [XmlArrayItem("ChildDeliverable")]
        public int[] DisplayValueIsAggregate { get; set; }

        public string ShouldDisplayValue { get; set; }

        public string ShouldDisplayVolume { get; set; }

        public string ShouldDisplayUnitCost { get; set; }
    }
}
