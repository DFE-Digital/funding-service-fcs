using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class QuickSearchTaskStory77
    {

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "77")]
        public void CheckTaskEntityExists()
        {
            TestBase.CrmConfiguration.Entity("Task");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "77")]
        public void CheckTaskEntityDefaultView()
        {
            TestBase.CrmConfiguration.Entity("Task").DefaultView().ViewNameEquals("My Tasks");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "77")]
        public void CheckMyTaskQuickSearchHasCorrectSearchFields()
        {
            TestBase.CrmConfiguration.Entity("Task").QuickView()
                .HasSearchField("Description")
                .HasSearchField("Task")
                .HasSearchField("Regarding")
                .HasSearchField("Status");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "77")]
        public void CheckMyTaskQuickSearchViewHasCorrectColumns()
        {
            TestBase.CrmConfiguration.Entity("Task").QuickView()
                     .HasColumn("Task")
                     .HasColumn("Regarding")
                     .HasColumn("Description")
                     .HasColumn("Due By")
                     .HasColumn("Status")
                     .HasColumn("Created On");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "77")]
        public void CheckMyTaskViewIsDescendingDate()
        {
            TestBase.CrmConfiguration.Entity("Task").View("My Tasks").HasSortColumn("Created On", XrmSortOrder.Descending);
        }
    }
}
