namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Period
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationFundingPeriod : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityExists()
        {
            CrmConfiguration.Entity("sfa_period").HasDisplayName("Funding Period");
        }
    }
}