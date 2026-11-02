namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "contractrequest")]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public enum contractAllocationHierarchyType
    {
        [XmlEnum("CONTRACT ALLOCATION")]
        CONTRACTALLOCATION,

        [XmlEnum("SUB ALLOCATION")]
        SUBALLOCATION
    }
}