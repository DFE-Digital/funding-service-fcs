namespace DocGenTests.Infrastructure
{
    using System.Configuration;
    using System.IO;
    using System.Net;
    using System.Web;
    using System.Xml.Serialization;
    using SFA.FCT.CrossDomain.Integration.Common.Authentication;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    public  class FundingStreamConfigService : IFundingStreamConfigService
    {
        public static FundingConfigurationType GetReferenceData(string period, string periodTypeCode, string fundingTypeCode)
        {
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            using (var client = new WebClient())
            {
                string requestArguments = $"?period={HttpUtility.UrlEncode(period)}&periodType={HttpUtility.UrlEncode(periodTypeCode)}&fundingType={HttpUtility.UrlEncode(fundingTypeCode)}";

                client.Headers[HttpRequestHeader.ContentType] = "application/xml";
                client.Headers[HttpRequestHeader.Accept] = "application/xml";
                client.Headers[HttpRequestHeader.Authorization] =
                    $"Bearer {AzureAuthenticator.GetAuthenticationResult("FundingStreamConfig")}";
                var url = ConfigurationManager.AppSettings["FscEnrichmentUrl"];
                var webResponse = client.DownloadString(url + requestArguments);

                var serialiser = new System.Xml.Serialization.XmlSerializer(typeof(FundingConfigurationType));

                using (TextReader tr = new StringReader(webResponse))
                {
                    return (FundingConfigurationType) serialiser.Deserialize(tr);
                }
            }
        }

        public FSCDeliverableStructureDefinitionResponse GetFullDeliverableStructure(string fundingStreamPeriodCode)
        {
            FSCDeliverableStructureDefinitionResponse deliverableStructure;

            using (var client = new WebClient())
            {
                client.Headers[HttpRequestHeader.ContentType] = "application/xml";
                client.Headers[HttpRequestHeader.Accept] = "application/xml";
                client.Headers[HttpRequestHeader.Authorization] =
                    $"Bearer {AzureAuthenticator.GetAuthenticationResult("FundingStreamConfig")}";
                var url = ConfigurationManager.AppSettings["FscEnrichmentUrl"];

                fundingStreamPeriodCode = HttpUtility.UrlEncode(fundingStreamPeriodCode);

                var webResponse = client.DownloadString(url + "?FundingStreamPeriod=" + fundingStreamPeriodCode);
                var serialiser = new XmlSerializer(typeof(FSCDeliverableStructureDefinitionResponse));
                using (TextReader tr = new StringReader(webResponse))
                {
                    deliverableStructure = (FSCDeliverableStructureDefinitionResponse)serialiser.Deserialize(tr);
                }
            }

            return deliverableStructure; ;
        }
    }
}
