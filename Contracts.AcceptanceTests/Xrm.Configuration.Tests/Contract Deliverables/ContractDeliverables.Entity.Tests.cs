namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Deliverables
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationContractDeliverables : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void EntityExists()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable")
                .HasDisplayName("Contract Deliverable")
                .IsUserOwned();
        }
    }
}