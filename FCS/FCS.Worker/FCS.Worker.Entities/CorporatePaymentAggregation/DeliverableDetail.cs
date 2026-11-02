// ReSharper disable CheckNamespace
namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation
{
    using System;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "urn:sfa:schemas:paymentsaggregation")]
    [XmlRoot(Namespace = "urn:sfa:schemas:paymentsaggregation", IsNullable = false)]
    public class DeliverableDetail
    {
        [XmlElement(Order = 0)]
        public int DeliverableCode { get; set; }

        [XmlElement(Order = 1)]
        public decimal DeliverableValue { get; set; }
    }
}
