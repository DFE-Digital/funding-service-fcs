namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Deliverable_Periods
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationContractDeliverablePeriods : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void EntityExists()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod")
                .HasDisplayName("Contract Deliverable Period")
                .IsUserOwned();
        }
    }
}