namespace SFA.FCT.Xrm.Configuration.Tests.Notification
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationNotifications
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void NotificationEntityMyNotificationsViewHasCorrectFields()
        {
            CrmConfiguration.Entity("sfa_notification").View("My Notifications")
                .HasColumn("createdon")
                .HasColumn("sfa_notificationtype")
                .HasColumn("sfa_notification");

        }

        public void NotificationEntityMyNotificationsViewHasCorrectSortOrder()
        {
            CrmConfiguration.Entity("sfa_notification").View("My Notifications")
                .HasSortColumn("createdon", XrmSortOrder.Descending);
        }
    }
}