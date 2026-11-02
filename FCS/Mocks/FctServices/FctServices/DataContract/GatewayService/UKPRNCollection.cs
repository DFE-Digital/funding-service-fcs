using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace FctServices.DataContract.GatewayService
{
    [CollectionDataContract(Name = "UKPRNCollection", Namespace = "http://schemas.sfa.gov.uk/cpds.gatewayservice", ItemName = "UKPRN")]
    [Serializable()]
    public class UKPRNCollection : List<UKPRN>
    {
    }
}