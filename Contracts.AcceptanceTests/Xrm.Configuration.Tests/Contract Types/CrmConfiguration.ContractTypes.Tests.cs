namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Types
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    [TestClass]
    public class XrmConfigurationContractTypes : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractTypeEntityExists()
        {
            CrmConfiguration.Entity("sfa_contracttype").HasDisplayName("Contract Type");
        }

        #endregion

        #region Relationships

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractTypeHasChildContract()
        {
            CrmConfiguration.Entity("sfa_contracttype").Relationship("sfa_contract")
                .HasFieldName("sfa_contracttype")
                .HasDisplayName("Contract Type")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        #endregion

        #region Attributes

        #endregion

        #region Forms

        #endregion

        #region Views

        #endregion
    }
}