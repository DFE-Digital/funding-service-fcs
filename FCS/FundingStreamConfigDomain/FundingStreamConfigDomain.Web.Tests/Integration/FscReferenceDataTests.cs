namespace FundingStreamConfigDomain.Web.Tests.Integration
{
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Web;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    
    [TestClass]
    public class FscReferenceDataTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void GetFscReferenceDataViaRest()
        {
            var data = RequestDataViaRest(GetUrlForService(),  "1516", "AY", "24+Loans");
            Assert.IsNotNull(data);
            Assert.IsTrue(data.FundingConfigurationList.Any());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetFscReferenceEopDataViaRest()
        {
            var data = RequestDataViaRest(GetUrlForService(), "1517", "EOP", "EOP");
            Assert.IsNotNull(data);
            Assert.IsTrue(data.FundingConfigurationList.Any());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetInvalidFscReferenceDataViaRest()
        {
            var data = RequestDataViaRest(GetUrlForService(), "1516", "TY", "29+Loans");
            Assert.IsNotNull(data);
            Assert.IsFalse(data.FundingConfigurationList.Any());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetFscReferenceEopDataViaRestWithoutAuthorizationFails()
        {
            var period = HttpUtility.UrlEncode("1517");
            var periodType = HttpUtility.UrlEncode("EOP");
            var fundingType = HttpUtility.UrlEncode("EOP");

            var queryData = string.Format("?period={0}&periodType={1}&fundingType={2}", period, periodType, fundingType);

            using (var client = new HttpClient())
            {
                var result = client.GetAsync(GetUrlForService() + queryData).Result;
                Assert.AreEqual(result.StatusCode, HttpStatusCode.Unauthorized);
            }
        }

        private FundingConfigurationType RequestDataViaRest(string url, string period, string periodType, string fundingType)
        {
            period = HttpUtility.UrlEncode(period);
            periodType = HttpUtility.UrlEncode(periodType);
            fundingType = HttpUtility.UrlEncode(fundingType);
            var queryData = string.Format("?period={0}&periodType={1}&fundingType={2}", period, periodType, fundingType);

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));;
                
                var result = client.GetAsync(url + queryData).Result;
                var xmlResponse = XElement.Parse(result.Content.ReadAsStringAsync().Result);
                var x = new XmlSerializer(typeof(FundingConfigurationType)).Deserialize(xmlResponse.CreateReader());
                return (FundingConfigurationType)x;
            }
        }

        private string GetUrlForService()
        {
            return new AppConfiguration()["FundingPolicyUrl"] + "/rest/referencedatalookup";
        }
    }
}