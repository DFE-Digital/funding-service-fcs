namespace SFA.FCT.Xrm.Configuration.Tests.Organisations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationOrganisations 
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void ProviderHasLegalName()
        {
            CrmConfiguration.Entity("account")
                .PrimaryAttribute()
                .HasDisplayName("Name")
                .HasType(XrmDataType.Text)
                .OfLength(160);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void ProviderHasUkprn()
        {
            CrmConfiguration.Entity("account")
                .Attribute("sfa_ukprn")
                .HasDisplayName("UKPRN")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void ProviderHasOrganisationId()
        {
            CrmConfiguration.Entity("account")
                .Attribute("sfa_organisationid")
                .HasDisplayName("Organisation ID")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        public void CaseLoadHasOrganisationName()
        {
            CrmConfiguration.Entity("sfa_caseload")
                .Attribute("sfa_organisationname")
                .HasDisplayName("Provider Legal Name")
                .HasType(XrmDataType.Text)
                .OfLength(150);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void CaseloadHasUkprn()
        {
            CrmConfiguration.Entity("sfa_caseload")
                .Attribute("sfa_ukprn")
                .HasDisplayName("UKPRN")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1022")]
        public void OrganisationHasOrgCategory()
        {
            CrmConfiguration.Entity("account")
                .Attribute("sfa_organisationcategory")
                .HasDisplayName("Organisation Category")
                .HasType(XrmDataType.OptionSet)
                .WithOption(229660000, "Provider")
                .WithOption(229660001, "LEP");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1022")]
        public void OrganisationHasLepCode()
        {
            CrmConfiguration.Entity("account")
                .Attribute("sfa_lepcode")
                .HasDisplayName("LEP Code")
                .HasType(XrmDataType.Text)
                .OfLength(10);
        }
    }
}