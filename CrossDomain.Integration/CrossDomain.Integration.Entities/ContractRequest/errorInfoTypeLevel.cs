namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "contractrequest")]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public enum errorInfoTypeLevel
    {
        MasterContract,
        Contract,
        Allocation,
        Deliverable,
        DeliverablePeriod
    }
}