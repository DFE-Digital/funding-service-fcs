namespace FundingStreamConfigDomain.Web.Tests.Integration.Atom
{
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class DeliverableSettingConfigurationFeedControllerTests : AtomFeedControllerIntegrationTestsBase
    {
        public const string LastPageUrl = "/api/funding-policies/deliverables/settings/notifications/changes";
        public const string AtomMediaType = "application/vnd.sfa.funding-policy.deliverable.setting.v1+atom+xml";

        protected override string VendorAtomMediaType => AtomMediaType;

        protected override string PageSpecificUrl => "/api/funding-policies/deliverables/settings/notifications/changes/{0}";

        protected override string MostRecentPageUrl => LastPageUrl;

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableSettingConfigurationAtomFeed_ShouldRejectWithMediaTypeNotSupported_WhenEndpointCalledWithUnsupportedMediaType()
        {
            ShouldRejectWithMediaTypeNotSupported_WhenEndpointCalledWithUnsupportedMediaType();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableSettingConfigurationAtomFeed_ShouldNotReject_IfMediaTypeIsAtomXml()
        {
            ShouldNotReject_IfMediaTypeIsAtomXml();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task DeliverableSettingConfigurationAtomFeed_ShouldReturnCorrectContentTypesForNextPrevLinks()
        {
            await ShouldReturnCorrectContentTypesForNextPrevLinks();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task DeliverableSettingConfigurationAtomFeed_ShouldReturnASyndicationFeedForTheCurrentPageWithNoNextLink()
        {
            await ShouldReturnASyndicationFeedForTheCurrentPageWithNoNextLink();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableSettingConfigurationAtomFeed_ShouldReject_IfMediaTypeIsAtomJson()
        {
            ShouldReject_IfMediaTypeIsAtomJson();
        }        

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverableSettingConfigurationAtomFeed_ShouldRejectWithUnsupportedMediaType_WhenCallingWithoutAMediaType()
        {
            ShouldRejectWithUnsupportedMediaType_WhenCallingWithoutAMediaType();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task DeliverableSettingConfigurationAtomFeed_ShouldReturnEntriesThatValidateAgainstXsd()
        {
            await ShouldReturnEntriesThatValidateAgainstXsd();
        }
    }
}