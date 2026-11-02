namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Text;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Operations.Web.Dtos;

    [TestClass]
    public class ContractDataControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);


        [TestMethod, TestCategory("IntegrationTest")]
        public void PublishProviderController_InitiatePublication_ShouldRespondWithHttpStatusCodeOk()
        {
            // arrange
            const string url = "/contractcleanup/cfsdata";

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                List<string> fundingIds = new List<string>()
                    {
                        "DADA-AY-2526-Contract-Provider-10010040-3_5","DADA-AY-2526-Contract-Provider-10010040-4_7"
                };
                //  var content = new StringContent($"\"{fundingIds}\"", Encoding.UTF8, "application/json");
                var command = JsonConvert.SerializeObject(fundingIds);
                var stringContent = new StringContent(command, Encoding.UTF8, "application/json");

                // act
                var httpResponseMessage = http.PostAsync(url, stringContent).Result;

            }


        }

    }
}
