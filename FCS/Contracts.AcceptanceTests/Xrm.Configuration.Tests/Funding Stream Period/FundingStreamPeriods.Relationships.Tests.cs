namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream_Period
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationFundingStreamPeriods
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodToFundingStream()
        {
            CrmConfiguration.Entity("sfa_fundingstream").Relationship("sfa_fundingstreamperiod")
                .HasFieldName("sfa_fundingstreamcodeid")
                .HasDisplayName("Funding Stream Code");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodToPeriod()
        {
            CrmConfiguration.Entity("sfa_period").Relationship("sfa_fundingstreamperiod")
                .HasFieldName("sfa_periodid")
                .HasDisplayName("Funding Period")
                .HasRequiredLevel(XrmRequirementLevel.BusinessRequired)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }
    }
}