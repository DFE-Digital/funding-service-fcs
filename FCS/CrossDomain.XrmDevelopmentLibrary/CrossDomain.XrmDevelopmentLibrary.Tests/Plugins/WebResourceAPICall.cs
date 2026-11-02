using System;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;
using CrossDomain.XrmDevelopmentLibrary.WorkflowsNS.Utilities;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Plugins
{
    [TestClass]
    public class WebResourceAPICall
    {
        [TestMethod]
        public void WebResourceAPICallTest()
        {
            var config = new ConfigDetails()
            {
                InputAzureAdInstance = "https://login.microsoftonline.com/{0}",
                InputAzureAppKey = "",
                InputAzureClientId = "",
                InputAzureResourceId = "http://fcsazuresfabisgov.onmicrosoft.com/FCS-DEV-ContractManagementService",
                InputAzureTenant = "fcsazuresfabisgov.onmicrosoft.com",

            };

            var intent = new string[] { "confirmreceiptofsignedcontract", "confirmpublicationtoprovider", "releaseforreview"};


            foreach (var s in intent)
            {
                string url =
                    "https://services-dat.fct-sfa.com/contractmanagement/contractissueandreturn/" + s;
                var postData =
                    string.Format(
                        "<ContractInformation xmlns:xsi =\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><ContractNumber>{0}</ContractNumber><MasterContractNumber>{1}</MasterContractNumber></ContractInformation>",
                        "24Loans-2051",
                        "SFA-2053");

                PostObjectwithpostData(url, postData, config);

            }
        }

        private void PostObjectwithpostData(string postUrl,  string postData, ConfigDetails config)
        {
           
                byte[] byteArray = Encoding.UTF8.GetBytes(postData);
                var request = (HttpWebRequest)WebRequest.Create(postUrl);
                request.Method = "POST";
                request.ContentType = "application/xml";
                request.ContentLength = byteArray.Length;

                AddAuthorizationHeader(request, config);
          
                using (var webpageStream = request.GetRequestStream())
                {
                    webpageStream.Write(byteArray, 0, byteArray.Length);
                }

                using (var webresponse = request.GetResponse())
                {
                    if (webresponse.GetResponseStream() == Stream.Null)
                    {
                        throw new Exception("GetResponseStream is null");
                    }

                    var response = (HttpWebResponse)webresponse;

                    Assert.AreEqual(response.StatusCode, HttpStatusCode.Accepted, "Status Not Equal" + response.StatusCode);

                    
                }
            
           
        }

        private void AddAuthorizationHeader(WebRequest client, ConfigDetails config)
        {
            client.PreAuthenticate = true;
            client.Headers.Add("Authorization",
                new AuthenticationHeaderValue("Bearer",
                    AzureAuthentication.GetAuthenticationResult(
                        config.InputAzureAdInstance,
                        config.InputAzureTenant,
                        config.InputAzureClientId,
                        config.InputAzureAppKey,
                        config.InputAzureResourceId).AccessToken).ToString());
        }

    }

    public class ConfigDetails
    {
        public string InputAzureAdInstance { get; set; }
        public string InputAzureTenant { get; set; }
        public string InputAzureClientId { get; set; }
        public string InputAzureAppKey { get; set; }
        public string InputAzureResourceId { get; set; }
    }
}
