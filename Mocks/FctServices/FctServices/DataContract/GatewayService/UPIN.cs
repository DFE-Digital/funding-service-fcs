using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace FctServices.DataContract.GatewayService
{
    [DataContract(Name = "UPIN", Namespace = "http://schemas.sfa.gov.uk/cpds.gatewayservice")]
    [Serializable()]
    public class UPIN
    {
        [OptionalField()]
        private string _upinData;

        [DataMember()]
        public string UpinData
        {
            get { return _upinData; }
            set { _upinData = value; }
        }
    }
}