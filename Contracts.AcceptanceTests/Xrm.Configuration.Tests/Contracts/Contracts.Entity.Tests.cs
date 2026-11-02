namespace SFA.FCT.Xrm.Configuration.Tests.Contracts
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationContracts : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityExists()
        {
            CrmConfiguration.Entity("sfa_contract")
                .HasDisplayName("Contract")
                .IsUserOwned();
        }
    }
}