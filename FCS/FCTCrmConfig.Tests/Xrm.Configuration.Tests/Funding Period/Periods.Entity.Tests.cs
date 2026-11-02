using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    [TestClass]
    public partial class XrmConfigurationFundingPeriod : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityExists()
        {
            TestBase.CrmConfiguration.Entity("sfa_period").HasDisplayName("Funding Period");
        }
    }
}
