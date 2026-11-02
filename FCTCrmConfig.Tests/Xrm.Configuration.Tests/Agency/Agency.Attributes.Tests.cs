using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationAgency : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "700")]
        public void AgencyHasCode()
        {
            TestBase.CrmConfiguration.Entity("sfa_agency")
                .Attribute("sfa_agencyshortcode")
                .HasType(XrmDataType.Text)
                .OfLength(20);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "700")]
        public void AgencyHasDescription()
        {
            TestBase.CrmConfiguration.Entity("sfa_agency")
                .Attribute("sfa_description")
                .HasType(XrmDataType.Text)
                .OfLength(255);
        }

    }
}
