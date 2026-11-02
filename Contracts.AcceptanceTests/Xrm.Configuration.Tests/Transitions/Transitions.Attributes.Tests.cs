namespace SFA.FCT.Xrm.Configuration.Tests.Transitions
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationTransitions
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasActionOnTaskField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_actionontask")
                .HasType(XrmDataType.OptionSet)
                .WithOption(229660003, "Do Nothing")
                .WithOption(229660000, "Mark Complete")
                .WithOption(229660001, "Reassign To Contract Owner")
                .WithOption(229660002, "Reassign To Contract Managers Team");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasCreateTaskField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_createtask")
                .HasType(XrmDataType.TwoOptions);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasDefaultAssignToField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_defaultassignto")
                .HasType(XrmDataType.OptionSet)
                .WithOption(229660007, "Previous Owner")
                .WithOption(229660000, "Contract Adviser")
                .WithOption(229660002, "Contract Advisers Team")
                .WithOption(229660005, "Contract Advisers Manager")
                .WithOption(229660001, "Contract Manager")
                .WithOption(229660003, "Contract Managers Team")
                .WithOption(229660006, "Contract Managers Manager")
                .WithOption(229660004, "Lead Contract Manager");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasFromStateField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_fromstate")
                .HasType(XrmDataType.OptionSet)
                .WithOption(229660000, "Draft")
                .WithOption(229660001, "Approved")
                .WithOption(229660002, "Replaced");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasRequiredChangeOfOwnershipField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_requireschangeofownership")
                .HasType(XrmDataType.TwoOptions);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasSecondaryAssignToField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_secondaryassignto")
                .HasType(XrmDataType.OptionSet)
                .WithOption(229660007, "Previous Owner")
                .WithOption(229660000, "Contract Adviser")
                .WithOption(229660002, "Contract Advisers Team")
                .WithOption(229660005, "Contract Advisers Manager")
                .WithOption(229660001, "Contract Manager")
                .WithOption(229660003, "Contract Managers Team")
                .WithOption(229660006, "Contract Managers Manager")
                .WithOption(229660004, "Lead Contract Manager");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasSubjectField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_subject")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasTaskDescriptionField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_taskdescription")
                .HasType(XrmDataType.Memo);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasTaskTypeField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_tasktype")
                .HasType(XrmDataType.OptionSet)
                .WithOption(229660000, "Review Contract")
                .WithOption(229660001, "Contract Awaiting Approval");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasToStateField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_tostate")
                .HasType(XrmDataType.OptionSet)
                .WithOption(229660000, "Draft")
                .WithOption(229660001, "Approved")
                .WithOption(229660002, "Replaced");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void TransitionEntityHasWfActionField()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_wfaction")
                .HasType(XrmDataType.OptionSet)
                .WithOption(229660001, "Allocate Contract")
                .WithOption(229660000, "Progress Contract");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1232")]
        public void TransitionEntityHasMaintainsPreviousContractOwner()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_maintainspreviouscontractowner")
                .HasType(XrmDataType.TwoOptions);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "9681")]
        public void TransitionEntityHasCallApi()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_callapi")
                .HasType(XrmDataType.TwoOptions);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "9681")]
        public void TransitionEntityHasRequiresANotification()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_requiresanotification")
                .HasType(XrmDataType.TwoOptions);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "9681")]
        public void TransitionEntityHasServiceIntent()
        {
            CrmConfiguration.Entity("sfa_transition")
                .Attribute("sfa_serviceintent")
                .HasType(XrmDataType.Text)
                .OfLength(100)
                .HasDisplayName("Service Intent");
        }

    }
}