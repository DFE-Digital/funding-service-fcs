using SFA.FCT.CrossDomain.Integration.Common.Atom;
using SFA.FCT.CrossDomain.Integration.Entities;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Web;
using System.Xml.Serialization;

namespace SFA.FCT.AllocationDeliveryDomain.Atom_Feed
{
    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter")]
    [XmlRoot(Namespace = "urn:sfa:schemas:allocation-delivery-performance", IsNullable = false)]
    public class AllocationDeliveryEntryContent : IEntryContent<AllocationDeliveryPerformance>
    {
        public AllocationDeliveryPerformance allocationDeliveryPerformance { get; set; }
        public void SetRootProperty(AllocationDeliveryPerformance value)
        {
            allocationDeliveryPerformance = value;
        }
    }
}