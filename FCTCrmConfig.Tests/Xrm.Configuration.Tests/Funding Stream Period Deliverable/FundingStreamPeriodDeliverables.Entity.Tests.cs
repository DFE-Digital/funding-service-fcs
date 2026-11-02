using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    [TestClass]
    public partial class XrmConfigurationFundingStreamPeriodDeliverables : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableEntityExists()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .HasDisplayName("Funding Stream Period Deliverable");
        }
    }
}
