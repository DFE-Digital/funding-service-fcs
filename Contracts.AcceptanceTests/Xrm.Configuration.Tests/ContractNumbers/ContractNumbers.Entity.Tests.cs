namespace SFA.FCT.Xrm.Configuration.Tests.ContractNumbers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationContractNumbers : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "432")]
        public void ContractNumberEntityExists()
        {
            CrmConfiguration.Entity("sfa_contractnumber")
                .HasDisplayName("Contract Number")
                .IsOrganisationOwned();
        }

        #endregion
    }
}