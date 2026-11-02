namespace SFA.FCT.Performancetests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Xml;
    using System.Xml.Serialization;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Microsoft.VisualStudio.TestTools.WebTesting;

    public class TestDCFSAtomFeed : WebTestPlugin
    {
        private const string MostRecentPageUrl = "/api/contracts/notifications/approvals";

        private SyndicationFeed _mostRecentlyRetrievedFeed = null;
        private List<Tuple<string, string, int>> _contractsInMostRecentlyRetrievedFeed = null;
 
        public bool VerifiyContractsAreInFeed(IEnumerable<contract> contractsToCheck)
        {
            RetrieveCurrentFeedContents();

            bool allPresent = false;

            foreach (var ctc in contractsToCheck)
            {
                allPresent = _contractsInMostRecentlyRetrievedFeed.Any(fc =>
                    fc.Item1 == ctc.contractNumber &&
                    fc.Item2 == ctc.contracts[0].contractNumber &&
                    fc.Item3 == ctc.contracts[0].contractVersionNumber);

                if (!allPresent)
                {
                    break;
                }
            }

            return allPresent;
        }

        public bool VerifyFeed()
        {
           bool anyPresent = false;
           RetrieveCurrentFeedContents();
           return !anyPresent;
        }

        private void RetrieveCurrentFeedContents()
        {
            _contractsInMostRecentlyRetrievedFeed = new List<Tuple<string, string, int>>();

            var retrievedFeed = CallEndpointAndReturnResult("application/atom+xml", MostRecentPageUrl);;
            _mostRecentlyRetrievedFeed = SyndicationFeed.Load(new XmlTextReader(new StringReader(retrievedFeed)));

            AddFeedContentsToRetrievedContractList();

            var link = _mostRecentlyRetrievedFeed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.PreviousRelationship);
            while (link != null)
            {
                retrievedFeed = CallEndpointAndReturnResult("application/atom+xml", link.Uri.AbsolutePath);
                _mostRecentlyRetrievedFeed = SyndicationFeed.Load(new XmlTextReader(new StringReader(retrievedFeed)));
                AddFeedContentsToRetrievedContractList();
                link = _mostRecentlyRetrievedFeed.Links.FirstOrDefault(li => li.RelationshipType == AtomRelationship.PreviousRelationship);
            }
        }

        private void AddFeedContentsToRetrievedContractList()
        {
            XmlWriterSettings ws = new XmlWriterSettings
                {
                    Indent = true,
                    IndentChars = " ",
                    OmitXmlDeclaration = true,
                    Encoding = new UTF8Encoding()
                };

            // this code is UGLY but right now is the quick and dirty way to sort out the additional root element
            // in the supplied content.
            foreach (var item in _mostRecentlyRetrievedFeed.Items)
            {
                XmlSyndicationContent content = (XmlSyndicationContent)item.Content;

                MemoryStream ms = new MemoryStream();
                XmlWriter w = XmlWriter.Create(ms, ws);
                content.WriteTo(w, "Content", "");
                w.Flush();
                ms.Position = 0;
                StreamReader sr = new StreamReader(ms);
                string xmlContent = sr.ReadToEnd();

                xmlContent = xmlContent.Replace("<Content type=\"text/xml\">\r\n", "");
                xmlContent = xmlContent.Replace("</Content>", "");

                ms = new MemoryStream();

                StreamWriter sw = new StreamWriter(ms);
                sw.WriteLine(xmlContent);
                sw.Flush();

                ms.Position = 0;

                XmlSerializer xs = new XmlSerializer(typeof(contract));
                var masterContract = xs.Deserialize(ms) as contract;

                _contractsInMostRecentlyRetrievedFeed.Add(
                    new Tuple<string, string, int>(
                        masterContract.contractNumber, 
                        masterContract.contracts[0].contractNumber, 
                        masterContract.contracts[0].contractVersionNumber));
            }
        }

        private static string CallEndpointAndReturnResult(string mediaType, string url)
        {
            var client = new HttpClient();
            client
                .DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult().AccessToken);
            //http://fct-contractservice-dat.cloudapp.net
            var responseMessage = client
                       .GetAsync(ConfigurationParameters.ContractManagementServiceUrl() + url)
                       .Result;

            var statusCode = responseMessage.StatusCode;

            if (statusCode != HttpStatusCode.OK)
            {
                throw new ApplicationException(string.Format("Http status code of {0} returned", statusCode));
            }
            
            string response = responseMessage
                            .Content
                            .ReadAsStringAsync()
                            .Result;

            return response;
        }
    }
}