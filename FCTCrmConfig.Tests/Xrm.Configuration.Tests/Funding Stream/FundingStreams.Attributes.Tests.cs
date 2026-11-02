using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingStreams : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasFundingStreamCodeField()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstream")
                .Attribute("sfa_fundingstreamcode")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasPeriodTypeNameField()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstream")
                .Attribute("sfa_fundingstreamname")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasFundingStreamShortCodeField()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstream")
                .Attribute("sfa_fundingstreamshortcode")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

    }
}