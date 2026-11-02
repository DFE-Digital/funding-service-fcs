namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class periodType
    {
        public periodType()
        {
            periodType1 = new periodTypeType();
        }

        [XmlElement("periodType", Order = 0)]
        public periodTypeType periodType1 { get; set; }

        [XmlElement(Order = 1)]
        public string period { get; set; }

        [XmlElement(DataType = "date", Order = 2)]
        public DateTime startDate { get; set; }

        [XmlElement(DataType = "date", Order = 3)]
        public DateTime endDate { get; set; }
    }
}