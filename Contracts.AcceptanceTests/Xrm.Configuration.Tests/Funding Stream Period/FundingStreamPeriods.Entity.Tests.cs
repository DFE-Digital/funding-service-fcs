namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream_Period
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationFundingStreamPeriods : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodEntityExists()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperiod")
                .HasDisplayName("Funding Stream Period");
        }

        #endregion
    }
}