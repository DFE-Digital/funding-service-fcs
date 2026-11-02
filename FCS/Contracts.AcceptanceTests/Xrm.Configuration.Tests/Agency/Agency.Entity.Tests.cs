namespace SFA.FCT.Xrm.Configuration.Tests.Agency
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationAgency : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "700")]
        public void AgencyEntityExists()
        {
            CrmConfiguration.Entity("sfa_agency").HasDisplayName("Agency");
        }
    }
}