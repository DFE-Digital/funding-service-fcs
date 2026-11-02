namespace ContractManagementService.AtomFeed.EntryContent
{
    using System.Xml.Serialization;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [XmlRoot(Namespace = "urn:sfa:apis:funding-policy", IsNullable = false)]
    public class DeliverableSettingConfigurationEntryContent : IEntryContent<DeliverableSettingConfiguration>
    {
        public DeliverableSettingConfiguration DeliverableSettingConfiguration { get; set; }

        public void SetRootProperty(DeliverableSettingConfiguration value)
        {
            DeliverableSettingConfiguration = value;
        }
    }
}
