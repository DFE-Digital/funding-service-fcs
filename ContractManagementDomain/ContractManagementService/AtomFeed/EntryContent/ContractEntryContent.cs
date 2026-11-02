namespace ContractManagementService.AtomFeed.EntryContent
{
    using System.Xml.Serialization;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [XmlRoot(Namespace = "urn:sfa:schemas:contract", IsNullable = false)]
    public class ContractEntryContent : IEntryContent<contract>
    {
        // ReSharper disable once InconsistentNaming
        public contract contract { get; set; }

        public void SetRootProperty(contract value)
        {
            contract = value;
        }
    }
}