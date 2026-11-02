namespace SFA.FCT.Xrm.Configuration.Tests.Transitions
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationTransitions
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormExists()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasNameField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_name");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasProcessField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_process");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasActionField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_wfaction");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasActionOnExistingTaskField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_actionontask");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasFromActionField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_fromaction");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasNextActionField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_nextaction");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasFromStateField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_fromstate");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasManagersTeamField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_managersteam");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasOwnerField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("ownerid");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasRequiresCreationOfTaskField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_createtask");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasManagersRequiresChangeOfOwnerField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_requireschangeofownership");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasMaintainsPreviousOwnerField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_maintainspreviousowner");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasSubjectField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_subject");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasTaskDescriptionField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_taskdescription");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasDefaultAssignToField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_defaultassignto");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionFormHasSecondaryAssignToField()
        {
            CrmConfiguration.Entity("sfa_transition").Form("Information", XrmFormType.Main)
                .Field("sfa_secondaryassignto");
        }
    }
}