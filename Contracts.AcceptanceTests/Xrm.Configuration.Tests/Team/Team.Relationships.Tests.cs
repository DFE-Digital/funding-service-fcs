namespace SFA.FCT.Xrm.Configuration.Tests.Team
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    [TestClass]
    public class XrmConfigurationTeam : TestBase
    {
        #region Relationships

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TeamHasChildContract()
        {
            CrmConfiguration.Entity("team").Relationship("sfa_transition", "sfa_managersteam")
                .HasFieldName("sfa_managersteam")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        #endregion
    }
}