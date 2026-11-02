namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream_Period_Deliverable
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationFundingStreamPeriodDeliverables : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableEntityExists()
        {
            CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .HasDisplayName("Funding Stream Period Deliverable");
        }
    }
}