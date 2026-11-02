// ReSharper disable CheckNamespace
namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType=true, Namespace="urn:sfa:schemas:paymentsaggregation")]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public enum AggregationPaymentType
    {
        PROFILE,
        CAPPING,
        RECONCILIATION,
    }
}