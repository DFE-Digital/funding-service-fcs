using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace FctServices.Test.ServiceTests
{
    [TestClass]
    public class CPDSGatewayServiceTests
    {
        [TestMethod]
        [TestCategory("CallThroughAppGateway")]
        public void CallGetProviderSummaryByNameWithAnEmptyString()
        {
            var gateway = new CPDSGatewayService.GatewayServiceContractClient();
            string response = gateway.GetProviderSummaryByName(string.Empty);
            
        }
    }
}
