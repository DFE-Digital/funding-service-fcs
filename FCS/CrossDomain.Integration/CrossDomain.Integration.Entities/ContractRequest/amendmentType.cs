namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = false)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public enum amendmentType
    {
        None,
        Variation,
        Notification
    }
}