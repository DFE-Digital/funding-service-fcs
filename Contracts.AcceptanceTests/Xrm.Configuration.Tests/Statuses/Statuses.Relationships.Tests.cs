namespace SFA.FCT.Xrm.Configuration.Tests.Statuses
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationStatuses
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void StatusHasChildContract()
        {
            CrmConfiguration.Entity("sfa_status").Relationship("sfa_contract")
                .HasFieldName("sfa_substatus")
                .HasDisplayName("Sub Status")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        public void StatusHasChildCaseload()
        {
            CrmConfiguration.Entity("sfa_status").Relationship("sfa_caseload")
                .HasFieldName("sfa_status")
                .HasDisplayName("Caseload Status")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void StatusHasChildOrganisation()
        {
            CrmConfiguration.Entity("sfa_status").Relationship("account")
                .HasFieldName("sfa_status")
                .HasDisplayName("Status")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void StatusHasFromAction()
        {
            CrmConfiguration.Entity("sfa_status").Relationship("sfa_transition", "sfa_fromaction")
                .HasFieldName("sfa_fromaction")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void StatusHasToAction()
        {
            CrmConfiguration.Entity("sfa_status").Relationship("sfa_transition", "sfa_nextaction")
                .HasFieldName("sfa_nextaction")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }
    }
}