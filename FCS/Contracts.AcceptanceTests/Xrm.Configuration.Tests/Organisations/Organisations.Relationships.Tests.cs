namespace SFA.FCT.Xrm.Configuration.Tests.Organisations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationOrganisations 
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void ProviderHasChildContract()
        {
            CrmConfiguration.Entity("account").Relationship("sfa_contract")
                .HasFieldName("sfa_providername")
                .HasDisplayName("Provider")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void ProviderHasChildCaseLoad()
        {
            CrmConfiguration.Entity("account").Relationship("sfa_caseload")
                .HasFieldName("sfa_organisationid")
                .HasDisplayName("Organisation")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }
    }
}