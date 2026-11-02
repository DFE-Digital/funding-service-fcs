using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Web;
using FctServices.DataContract.GatewayService;

namespace FctServices.MessageContract.GatewayService
{
    [MessageContract(IsWrapped = false)]
    public class GProvByUKPRINRequest
    {
        [MessageBodyMember(Namespace = "http://schemas.sfa.gov.uk/cpds.gatewayservice", Order = 0)]
        public UKPRNCollection UKPRNs;
    }
}