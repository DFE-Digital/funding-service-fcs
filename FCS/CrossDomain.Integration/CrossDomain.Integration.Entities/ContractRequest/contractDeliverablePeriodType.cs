namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class contractDeliverablePeriodType
    {
        public contractDeliverablePeriodType()
        {
            periodType = new periodTypeType();
        }

        [XmlElement(Order = 0)]
        public string correlationId { get; set; }

        [XmlElement(Order = 1)]
        public int year { get; set; }

        [XmlElement(Order = 2)]
        public int period { get; set; }

        [XmlElement(Order = 3)]
        public periodTypeType periodType { get; set; }

        [XmlElement(Order = 4)]
        public decimal? unitCost { get; set; }

        [XmlElement(Order = 5)]
        public int? plannedVolume { get; set; }

        [XmlElement(Order = 6)]
        public decimal? plannedValue { get; set; }

        [XmlElement(Order = 7)]
        public bool aggregate { get; set; }

        [XmlElement(Order = 8)]
        public string periodName { get; set; }
    }
}