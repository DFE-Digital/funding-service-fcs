using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    [TestClass]
    public partial class XrmConfigurationFundingStreams : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingTypeEntityExists()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstream")
                .HasDisplayName("Funding Stream");
        }

        #endregion
    }
}
