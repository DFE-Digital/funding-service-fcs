namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationFundingStreams : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingTypeEntityExists()
        {
            CrmConfiguration.Entity("sfa_fundingstream")
                .HasDisplayName("Funding Stream");
        }

        #endregion
    }
}