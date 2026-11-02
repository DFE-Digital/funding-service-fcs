// ReSharper disable CheckNamespace
namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation
{
    using System;
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "urn:sfa:schemas:paymentsaggregation")]
    [XmlRoot(Namespace = "urn:sfa:schemas:paymentsaggregation", IsNullable = false)]
    public class AllocationPeriod
    {
        public AllocationPeriod()
        {
            Aggregations = new List<Aggregation>();
        }

        [XmlElement(Order = 0)]
        public AllocationPeriodPeriodTypeCode PeriodTypeCode { get; set; }

        [XmlElement(Order = 1)]
        public string Period { get; set; }

        [XmlArray(Order = 2)]
        [XmlArrayItem("Aggregation", IsNullable = false)]
        public List<Aggregation> Aggregations { get; set; }
    }
}
