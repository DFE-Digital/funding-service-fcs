using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using NUnit.Framework;

namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    class DocumentPartsServicePageObject
    {
        public int ResponseCode { get; set; }
        private string Response { get; set; }

        internal void InvokeServiceWithContractDocument(XmlDocument contractDocument)
        {
            using (WebClient wc = new WebClient())
            {
                wc.Headers[HttpRequestHeader.ContentType] = "application/xml";
                wc.Headers[HttpRequestHeader.Accept] = "application/xml";

                try
                {
                    Response = wc.UploadString("http://localhost/FundingStreamConfigDomain/rest/document/convert", "PUT", contractDocument.OuterXml);
                }
                catch (WebException we)
                {
                    if (we.Status == WebExceptionStatus.ProtocolError)
                    {
                        var response = we.Response as HttpWebResponse;
                        if (response != null)
                        {
                            ResponseCode = (int)response.StatusCode;
                        }
                        else
                        {
                            // no http status code available
                        }
                    }
                    else
                    {
                        // no http status code available
                    }
                }
            }

        }

        internal void VerifyResponseContainsTheseDocumentPartsInOrderAndAssertIfNotCorrect(string multilineText)
        {
            string[] expectedParts = multilineText.Split('\n');

            XmlDocument responseDocument = new XmlDocument();
            responseDocument.LoadXml(Response);

            XmlNode delimitedPartsNode = responseDocument.SelectSingleNode("/DocumentPartSelectResponse/DelimitedParts");
            Assert.NotNull(delimitedPartsNode, "DelimitedPartsNode is null and shouldn't be");
            string delimitedParts = delimitedPartsNode.InnerText;

            string[] documentPartsFromService = 
                (from string part 
                    in delimitedParts.Split(',')
                    select part.Trim()
                ).ToArray();

            for (int i = 0; i < expectedParts.Length; i++)
            {
                Assert.Greater(documentPartsFromService.Length, i, "not enough values in response");
                Assert.AreEqual(documentPartsFromService[i], expectedParts[i], string.Format("Part {0} is not as expected.  Expected '{1}' and found '{2}'", i, expectedParts[i], documentPartsFromService[i]));
            }

        }

    }
}
