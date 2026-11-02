namespace SFA.FCT.Xrm.Configuration.Tests.Notification
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationNotifications : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1660")]
        public void NotificationEntityExists()
        {
            CrmConfiguration.Entity("sfa_notification").HasDisplayName("Notification");
        }

        #endregion
    }
}