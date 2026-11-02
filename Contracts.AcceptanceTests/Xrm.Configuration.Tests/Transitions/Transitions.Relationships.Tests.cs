namespace SFA.FCT.Xrm.Configuration.Tests.Transitions
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationTransitions
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionHasChildContract()
        {
            CrmConfiguration.Entity("sfa_transition").Relationship("sfa_contract")
                .HasFieldName("sfa_nextaction")
                .HasDisplayName("Next Action")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void StatusHasDefaultBulkAction()
        {
            CrmConfiguration.Entity("sfa_transition").Relationship("sfa_status")
                .HasFieldName("sfa_defaultbulkaction")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }
    }
}