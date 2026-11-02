namespace SFA.FCT.Xrm.Configuration.Tests.Agency
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationAgency
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "700")]
        public void AgencyHasCode()
        {
            CrmConfiguration.Entity("sfa_agency")
                .Attribute("sfa_agencyshortcode")
                .HasType(XrmDataType.Text)
                .OfLength(20);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "700")]
        public void AgencyHasDescription()
        {
            CrmConfiguration.Entity("sfa_agency")
                .Attribute("sfa_description")
                .HasType(XrmDataType.Text)
                .OfLength(255);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "700")]
        public void AgencyHasContractReference()
        {
            CrmConfiguration.Entity("sfa_agency")
                .Attribute("sfa_contractreferenceprefix")
                .HasType(XrmDataType.Text)
                .OfLength(20);
        }
    }
}