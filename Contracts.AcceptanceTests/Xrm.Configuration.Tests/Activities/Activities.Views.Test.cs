namespace SFA.FCT.Xrm.Configuration.Tests.Activities
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationActivities
    {
        #region Views

        // Is there a My Task view on the Task entity
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "76")]
        public void MyTasksViewExists()
        {
            CrmConfiguration.Entity("Task").View("My Tasks");
        }

        // Does the My Task view have the correct columns
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "76")]
        public void TaskEntityMyTasksViewHasCorrectFields()
        {
            CrmConfiguration.Entity("Task").View("My Tasks")
                .HasColumn("Task")
                .HasColumn("regardingobjectid")
                .HasColumn("description")
                .HasColumn("statuscode")
                .HasColumn("createdon");
        }

        // Does the default view have the correct sort order
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "76")]
        public void TaskEntityMyTasksViewHasCorrectSort()
        {
            CrmConfiguration.Entity("Task").View("My Tasks")
                .HasSortColumn("createdon", XrmSortOrder.Descending);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void DefaultViewExists()
        {
            CrmConfiguration.Entity("Task").DefaultView().ViewNameEquals("All Open Tasks");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void TaskEntityDefaultViewHasCorrectFields()
        {
            CrmConfiguration.Entity("Task").DefaultView()
                .HasColumn("Task")
                .HasColumn("regardingobjectid")
                .HasColumn("description")
                .HasColumn("scheduledend")
                .HasColumn("statuscode")
                .HasColumn("createdon")
                .HasColumn("ownerid");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void TaskEntityDefaultViewHasCorrectSort()
        {
            CrmConfiguration.Entity("Task").DefaultView()
                .HasSortColumn("regardingobjectid", XrmSortOrder.Ascending)
                .HasSortColumn("Task", XrmSortOrder.Ascending);
        }

        // Does the Quick Search view exist on the contract entity
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "77")]
        public void TaskEntityQuickSearchViewExists()
        {
            CrmConfiguration.Entity("Task").QuickView();
        }

        // Does the quick search view have the correct columns
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "77")]
        public void TaskEntityQuickSearchViewHasCorrectColumns()
        {
            CrmConfiguration.Entity("Task").QuickView()
                .HasColumn("subject")
                .HasColumn("regardingobjectid")
                .HasColumn("description")
                .HasColumn("scheduledend")
                .HasColumn("statuscode")
                .HasColumn("createdon")
                .HasColumn("ownerid");
        }

        // Does the quick search view have the correct filters
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "77")]
        public void TaskEntityQuickSearchHasCorrectFilters()
        {
            CrmConfiguration.Entity("Task").QuickView()
                .HasFilter("statecode", XrmFilterOperator.EqualTo, "0");
        }

        // Does the quick search view have the correct find columns
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "77")]
        public void TaskEntityQuickSearchHasCorrectSearchFields()
        {
            CrmConfiguration.Entity("Task").QuickView()
                .HasSearchField("ownerid")
                .HasSearchField("regardingobjectid")
                .HasSearchField("statuscode")
                .HasSearchField("description");
        }

        // Does the quick search view have the correct column sort order
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "77")]
        public void TaskEntityQuickSearchHasCorrectSortColumns()
        {
            CrmConfiguration.Entity("Task").QuickView()
                .HasSortColumn("createdon", XrmSortOrder.Descending);
        }

        #endregion

        #region Ribbon 

        #endregion
    }
}