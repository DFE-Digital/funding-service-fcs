namespace SFA.FCT.CrossDomain.Integration.Common.Atom.EntryContent
{
    using System.Xml.Serialization;
    using Entities.CorporateSchema.Contract;

    [XmlRoot(Namespace = "urn:sfa:schemas:contract:allocation", IsNullable = false)]
    public class ContractAllocationsContractAllocationEntryContent : IEntryContent<contractAllocationsContractAllocation>
    {
        public contractAllocationsContractAllocation ContractAllocationsContractAllocation { get; set; }

        public void SetRootProperty(contractAllocationsContractAllocation value)
        {
            ContractAllocationsContractAllocation = value;
        }
    }
}
