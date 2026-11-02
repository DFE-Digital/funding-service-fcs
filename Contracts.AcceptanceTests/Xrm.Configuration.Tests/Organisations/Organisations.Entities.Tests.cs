namespace SFA.FCT.Xrm.Configuration.Tests.Organisations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationOrganisations : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void OrganisationEntityExists()
        {
            CrmConfiguration.Entity("account").HasDisplayName("Organisation");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        public void CaseLoadEntityExists()
        {
            CrmConfiguration.Entity("sfa_caseload").HasDisplayName("Caseload").IsUserOwned();
        }
    }
}