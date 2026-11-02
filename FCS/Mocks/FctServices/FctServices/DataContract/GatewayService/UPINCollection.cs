using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace FctServices.DataContract.GatewayService
{
    [CollectionDataContract(Name = "UPINCollection", Namespace = "http://schemas.sfa.gov.uk/cpds.gatewayservice", ItemName = "UPIN")]
    [Serializable()]
    public class UPINCollection : List<UPIN>
    {
    }
}