using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    [TestClass]
    public partial class XrmConfigurationFundingStreamPeriods : TestBase
    {
        #region Entity
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodEntityExists()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperiod")
                .HasDisplayName("Funding Stream Period");
        }
        #endregion
    }
}
