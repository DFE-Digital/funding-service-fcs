namespace SFA.FCT.Xrm.Configuration.Tests.Statuses
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationStatuses : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void StatusEntityExists()
        {
            CrmConfiguration.Entity("sfa_status").HasDisplayName("Status").IsOrganisationOwned();
        }
    }
}