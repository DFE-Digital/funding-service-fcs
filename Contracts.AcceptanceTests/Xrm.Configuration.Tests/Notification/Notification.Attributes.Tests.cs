namespace SFA.FCT.Xrm.Configuration.Tests.Notification
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationNotifications
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1066")]
        public void NotificationEntityContainsNotification()
        {
            CrmConfiguration.Entity("sfa_notification")
                .Attribute("sfa_notification").HasType(XrmDataType.Memo);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1066")]
        public void NotificationEntityContainsNotificationType()
        {
            CrmConfiguration.Entity("sfa_notification")
                .Attribute("sfa_notificationtype").HasType(XrmDataType.OptionSet);
        }
    }
}