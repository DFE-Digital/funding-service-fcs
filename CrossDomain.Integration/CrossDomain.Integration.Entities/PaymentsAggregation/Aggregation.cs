// ReSharper disable CheckNamespace
namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation
{
    using System;
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType=true, Namespace="urn:sfa:schemas:paymentsaggregation")]
    [XmlRoot(Namespace="urn:sfa:schemas:paymentsaggregation", IsNullable=false)]
    public class Aggregation
    {
        public Aggregation()
        {
            DeliverableDetails = new List<DeliverableDetail>();
        }

        [XmlElement(Order = 0)]
        public AggregationPaymentType PaymentType { get; set; }
        
        [XmlElement(Order=1)]
        public string SubnominalCode { get; set; }
        
        [XmlElement(Order=2)]
        public decimal AggregatedValue { get; set; }

        [XmlElement(Order=3)]
        public bool PostedFlag { get; set; }

        [XmlArray(Order=4)]
        [XmlArrayItem("DeliverableDetail", IsNullable=false)]
        public List<DeliverableDetail> DeliverableDetails { get; set; }
    }
}