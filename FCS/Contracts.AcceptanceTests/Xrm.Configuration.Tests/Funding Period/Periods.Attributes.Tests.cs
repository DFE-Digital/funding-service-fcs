namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Period
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationFundingPeriod
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasPeriodField()
        {
            CrmConfiguration.Entity("sfa_period")
                .Attribute("sfa_period")
                .HasType(XrmDataType.Text)
                .OfLength(50);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasStartdateField()
        {
            CrmConfiguration.Entity("sfa_period")
                .Attribute("sfa_startdate")
                .HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasEnddateField()
        {
            CrmConfiguration.Entity("sfa_period")
                .Attribute("sfa_enddate")
                .HasType(XrmDataType.DateTime);
        }
    }
}