namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;
    using System.Xml.Serialization;

    [Serializable]
    public class ExtendedContractAllocation : contractAllocationsContractAllocation
    {
        [XmlIgnore]
        public decimal? ValueVariation { get; set; }

        public override string ToString()
        {
            return $"AllocationNumber: {contractAllocationNumber}";
        }
    }
}
