namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Allocations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationContractAllocations : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "701")]
        public void ContractEntityExists()
        {
            CrmConfiguration.Entity("sfa_contractallocation")
                .HasDisplayName("Contract Allocation")
                .IsUserOwned();
        }
    }
}