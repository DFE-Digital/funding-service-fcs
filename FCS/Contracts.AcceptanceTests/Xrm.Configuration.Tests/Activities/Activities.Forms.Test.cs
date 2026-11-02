namespace SFA.FCT.Xrm.Configuration.Tests.Activities
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationActivities
    {
        // Is there a Task form in the system for the Task entity.
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "81")]
        public void TaskFormExists()
        {
            CrmConfiguration.Entity("Task").Form("Task", XrmFormType.Main);
        }

        // Is there a field called Task Completed By is on the contract form.
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "81")]
        public void TaskFormHasTaskCompletedBy()
        {
            CrmConfiguration.Entity("task").Form("Task", XrmFormType.Main)
                .Field("sfa_taskcompletedby").IsDisabled(true);
        }
    }
}