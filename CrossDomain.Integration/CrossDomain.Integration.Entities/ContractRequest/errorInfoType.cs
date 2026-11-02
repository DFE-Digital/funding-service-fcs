namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class errorInfoType
    {
        [XmlAttribute]
        public string correlationId { get; set; }

        [XmlAttribute]
        public errorInfoTypeLevel level { get; set; }

        [XmlText]
        public string Value { get; set; }

        public ErrorSeverity Severity { get; set; }
    }
}