namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class contractor
    {
        [XmlElement(Order = 0)]
        public string organisationIdentifier { get; set; }

        [XmlElement(Order = 1)]
        public int ukprn { get; set; }

        [XmlElement(Order = 2)]
        public string legalName { get; set; }

        [XmlElement(Order = 3)]
        public string registeredCompanyNumber { get; set; }

        [XmlElement(Order = 4)]
        public int organisationAddressIdentifier { get; set; }

        [XmlElement(Order = 5)]
        public string addressLine1 { get; set; }

        [XmlElement(Order = 6)]
        public string addressLine2 { get; set; }

        [XmlElement(Order = 7)]
        public string addressLine3 { get; set; }

        [XmlElement(Order = 8)]
        public string addressLine4 { get; set; }

        [XmlElement(Order = 9)]
        public string town { get; set; }

        [XmlElement(Order = 10)]
        public string county { get; set; }

        [XmlElement(Order = 11)]
        public string postcode { get; set; }

        [XmlElement(Order = 12)]
        public string organisationStatus { get; set; }

        [XmlElement(Order = 13)]
        public string Upin { get; set; }

        [XmlElement(Order = 14)]
        public string CharityNumber { get; set; }
    }
}