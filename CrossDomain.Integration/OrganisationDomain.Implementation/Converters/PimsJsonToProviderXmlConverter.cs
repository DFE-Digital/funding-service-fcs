using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace OrganisationDomain.Implementation.Converters
{

    public class PimsJsonToProviderXmlConverter : IPimsJsonToProviderXmlConverter
    {
        public XDocument Convert(string json)
        {
            var provider = JObject.Parse(json);

            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";
            XNamespace xsi = "http://www.w3.org/2001/XMLSchema-instance";

            return new XDocument(
                new XElement(ns + "ProviderDataSetV2",
                    new XAttribute(
                        XNamespace.Xmlns + "xsi",
                        xsi),

                    new XElement(ns + "Provider",
                        new XAttribute(
                            "ProviderSequenceNumber",
                            provider["providerSequenceNumber"]?.ToString()),

                        new XElement(
                            ns + "Upin",
                            provider["upin"]?.ToString()),

                        new XElement(
                            ns + "UKPRN",
                            provider["ukprn"]?.ToString()),

                        new XElement(
                            ns + "TradingName",
                            provider["tradingName"]?.ToString()),

                        new XElement(
                            ns + "RegisteredName",
                            provider["registeredName"]?.ToString()),

                        new XElement(
                            ns + "ProviderType",
                            new XElement(
                                ns + "ProviderType",
                                provider["providerType"]?.ToString())
                        ),

                        new XElement(
                            ns + "Codes",
                            new XElement(
                                ns + "CodeType",
                                new XAttribute("id", "91"),
                                new XElement(
                                    ns + "CodeType",
                                    "OrganisationStatus")
                            ),

                            new XElement(
                                ns + "CodeValue",
                                new XElement(
                                    ns + "CodeValueDesc",
                                    provider["status"]?.ToString())
                            )
                        )
                    )
                )
            );
        }
    }
}
