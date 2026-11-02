namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream_Period
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationFundingStreamPeriods
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodEntityHasFundingStreamPeriodCodeField()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperiod")
                .Attribute("sfa_fundingstreamperiodcode")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

    }
}