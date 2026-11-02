using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Web;

namespace FctServices.MessageContract.GatewayService
{
    [MessageContract(IsWrapped = false)]
    public class GProvByNameRequest
    {
        [MessageBodyMember(Namespace = "http://schemas.sfa.gov.uk/cpds.gatewayservice", Order = 0)]
        public string TradingName;
    }

}