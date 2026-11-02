namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationFundingStreams
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasFundingStreamCodeField()
        {
            CrmConfiguration.Entity("sfa_fundingstream")
                .Attribute("sfa_fundingstreamcode")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasPeriodTypeNameField()
        {
            CrmConfiguration.Entity("sfa_fundingstream")
                .Attribute("sfa_fundingstreamname")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }
    }
}