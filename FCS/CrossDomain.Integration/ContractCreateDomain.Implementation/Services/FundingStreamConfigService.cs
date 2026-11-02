namespace SFA.FCT.ContractCreateDomain.Implementation.Services
{
    using System.Configuration;
    using System.IO;
    using System.Net;
    using System.Web;
    using System.Xml.Serialization;
    using CrossDomain.Integration.Common.Authentication;
    using CrossDomain.Integration.Entities;

    public class FundingStreamConfigService : IFundingStreamConfigService
    {
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

            return deliverableStructure;
        }
    }
}
