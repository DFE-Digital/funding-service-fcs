namespace PaymentManagementServiceTest
{
    using System.Net;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class PaymentManagementServiceUnitTest //: PaymentManagementTestBase
    {
        public const string baseUrl = "http://localhost/PaymentManagementService";
        private contract Contract;
        
        [TestCleanup]
        public void CleanUp()
        {
            //RemoveMasterAndChildContracts(CorporateContractGuid);
        }

        [TestMethod, TestCategory("Dev")]
        public void PaymentManagementControllerContractApprovedTest()
        {
            object payload = new object();
            const string contractNumber = "MAIN-2263";
            const string masterContractNumber = "SFA-2819";

            string url = string.Format("{0}/contract/{1}/approved?masterContractNumber={2}", baseUrl, contractNumber, masterContractNumber);
            PutObject(url, payload);
        }

        public void PutObject(string postUrl, object payload)
        {
            var request = (HttpWebRequest)WebRequest.Create(postUrl);
            request.Method = "PUT";
            request.ContentType = "application/xml";
            request.ContentLength = 0;
            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            {
                var respStatus = response.StatusCode;
                Assert.AreEqual(HttpStatusCode.OK, respStatus);
            }
        }
    }
}
