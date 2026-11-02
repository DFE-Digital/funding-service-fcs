namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.XPath;
    using Infrastructure.DTO;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TechTalk.SpecFlow;

    [Binding]
    public class FundingStreamConfigSteps
    {
        private IReadOnlyCollection<FundingStreamPeriodDeliverableSettingInfo> _atomFeedDeliverableSettings;

        [When(@"Funding Stream Deliverable settings are retrieved via atom feed")]
        public void WhenFundingStreamDeliverableSettingsAreRetrievedViaAtomFeed()
        {
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            string feedHost = ConfigurationManager.AppSettings["FscAtomFeedHost"];
            string feedUri = ConfigurationManager.AppSettings["FscAtomFeedDeliverableSettingConfigurationUrl"];
            AzureAuthenticationConfig authenticationConfig = new AzureAuthenticationConfig
            {
                AadInstance = ConfigurationManager.AppSettings["ida:AADInstance_FundingStreamConfig"],
                Tenant = ConfigurationManager.AppSettings["ida:Tenant_FundingStreamConfig"],
                ClientId = ConfigurationManager.AppSettings["ida:ClientId_FundingStreamConfig"],
                AppKey = ConfigurationManager.AppSettings["ida:AppKey_FundingStreamConfig"],
                ResourceId = ConfigurationManager.AppSettings["ida:ResourceId_FundingStreamConfig"]
            };
            const string atomMediaType = "application/vnd.sfa.funding-policy.deliverable.setting.v1+atom+xml";

            IReadOnlyCollection<SyndicationFeed> feedPages = AtomFeedReader.ReadAllPages($"{feedHost}/{feedUri}", authenticationConfig, atomMediaType);

            _atomFeedDeliverableSettings =
                feedPages
                .SelectMany(page => page.Items)
                .Select(ExtractXmlFromAtomItem)
                .Select(TransformXmlToFundingStreamPeriodDeliverableSettingInfo)
                .ToList();
        }

        [Then(@"all Funding Stream Deliverable settings from CRM policy config are present")]
        public void ThenAllFundingStreamDeliverableSettingsFromCrmPolicyConfigArePresent()
        {
            IReadOnlyCollection<FundingStreamPeriodDeliverableSettingInfo> crmDeliverableSettings =
                CrmFundingStreamPeriodDeliverableRepository.GetAllFundingStreamPeriodDeliverableSettings();

            Assert.AreEqual(crmDeliverableSettings.Count, _atomFeedDeliverableSettings.Count, "Setting counts differ between atom feed and CRM");
            Assert.IsTrue(crmDeliverableSettings.All(ds => _atomFeedDeliverableSettings.Contains(ds)), "Settings differ between atom feed and CRM");
        }

        private static string ExtractXmlFromAtomItem(SyndicationItem item)
        {
            XmlSyndicationContent content = (XmlSyndicationContent)item.Content;
            XmlWriterSettings ws = new XmlWriterSettings
            {
                Indent = true,
                IndentChars = " ",
                OmitXmlDeclaration = true,
                Encoding = new UTF8Encoding()
            };

            MemoryStream ms = new MemoryStream();
            XmlWriter w = XmlWriter.Create(ms, ws);
            content.WriteTo(w, "Content", "");
            w.Flush();
            ms.Position = 0;
            StreamReader sr = new StreamReader(ms);
            string xmlContent = sr.ReadToEnd();

            xmlContent = xmlContent.Replace("<Content type=\"text/xml\">\r\n", "");
            xmlContent = xmlContent.Replace("</Content>", "");
            xmlContent = xmlContent.Replace(" xmlns=\"urn:sfa:apis:funding-policy\"", "");
            xmlContent = xmlContent.Replace(" xmlns=\"urn:sfa:schemas:funding-policy\"", "");

            return xmlContent;
        }

        private static FundingStreamPeriodDeliverableSettingInfo TransformXmlToFundingStreamPeriodDeliverableSettingInfo(string atomItemXml)
        {
            XDocument doc = XDocument.Load(new XmlTextReader(new StringReader(atomItemXml)));

            string settingName = doc.Root.XPathSelectElement("//SettingName").Value;
            string settingValue = doc.Root.XPathSelectElement("//Value").Value;

            if (settingName == "planningunit")
            {
                settingValue = settingValue.Replace(" ", "");
            }

            return new FundingStreamPeriodDeliverableSettingInfo
            (
                fundingStreamPeriodCode: doc.Root.XPathSelectElement("//FundingStreamPeriodCode").Value,
                deliverableCode: int.Parse(doc.Root.XPathSelectElement("//DeliverableCode").Value),
                settingName: settingName,
                settingValue: settingValue
            );
        }
    }
}
