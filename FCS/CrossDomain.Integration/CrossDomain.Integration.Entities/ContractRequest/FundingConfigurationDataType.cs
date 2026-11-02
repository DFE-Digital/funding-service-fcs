namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    public class FundingConfigurationDataType
    {
        [XmlElement(Order = 0)]
        public string FundingTypeCode { get; set; }

        [XmlElement(Order = 1)]
        public string FundingStreamCode { get; set; }

        [XmlElement(Order = 2)]
        public string FundingStreamId { get; set; }

        [XmlElement(Order = 3)]
        public string FundingStreamName { get; set; }

        [XmlElement(Order = 5)]
        public string FundingStreamCodeId { get; set; }

        [XmlElement(Order = 6)]
        public string FundingStreamPeriodCode { get; set; }

        [XmlElement(Order = 7)]
        public string Period { get; set; }

        [XmlElement(IsNullable = true, Order = 8)]
        public DateTime? FundingPeriodStartDate { get; set; }

        [XmlElement(IsNullable = true, Order = 9)]
        public DateTime? FundingPeriodEndDate { get; set; }

        [XmlElement(Order = 10)]
        public string PeriodTypeName { get; set; }

        [XmlElement(Order = 11)]
        public string PeriodTypeCode { get; set; }
    }
}