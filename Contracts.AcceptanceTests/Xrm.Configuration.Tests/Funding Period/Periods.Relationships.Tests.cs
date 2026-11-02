namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Period
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    public partial class XrmConfigurationFundingPeriod
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingPeriodToPeriodType()
        {
            CrmConfiguration.Entity("sfa_periodtype").Relationship("sfa_period")
                .HasFieldName("sfa_periodtypeid")
                .HasDisplayName("Period Type");
        }
    }
}