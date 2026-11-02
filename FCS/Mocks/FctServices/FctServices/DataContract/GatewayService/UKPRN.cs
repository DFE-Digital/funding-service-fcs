using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace FctServices.DataContract.GatewayService
{

    [DataContract(Name = "UKPRN", Namespace = "http://schemas.sfa.gov.uk/cpds.gatewayservice")]
    [Serializable()]
    public class UKPRN
    {

        [OptionalField()]
        private string _ukprnData;

        [DataMember()]
        public string UKPRNData
        {
            get { return _ukprnData; }
            set { _ukprnData = value; }
        }
    }
}