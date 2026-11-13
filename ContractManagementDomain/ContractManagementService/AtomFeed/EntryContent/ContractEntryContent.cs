namespace ContractManagementService.AtomFeed.EntryContent
{
    using System.Xml.Serialization;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [XmlRoot(Namespace = "urn:sfa:schemas:contract", IsNullable = false)]
    public class ContractEntryContent : IEntryContent<Contract>
    {
        // ReSharper disable once InconsistentNaming
        public Contract contract { get; set; }

        public void SetRootProperty(Contract value)
        {
            contract = value;
        }
    }
}