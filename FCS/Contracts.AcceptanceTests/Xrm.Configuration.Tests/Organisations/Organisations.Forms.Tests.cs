namespace SFA.FCT.Xrm.Configuration.Tests.Organisations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationOrganisations 
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void OrganisationMainFormHasCorrectFields()
        {
            CrmConfiguration.Entity("account").Form("Account", XrmFormType.Main)
                .Field("name");
            CrmConfiguration.Entity("account").Form("Account", XrmFormType.Main)
                .Field("sfa_ukprn");
            CrmConfiguration.Entity("account").Form("Account", XrmFormType.Main)
                .Field("sfa_status");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void OrganisationQuickViewFormHasCorrectFields()
        {
            CrmConfiguration.Entity("account").Form("account card", XrmFormType.QuickView)
                .Field("sfa_ukprn");
            CrmConfiguration.Entity("account").Form("account card", XrmFormType.QuickView)
                .Field("sfa_status");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void CaseLoadMainFormHasCorrectFields()
        {
            CrmConfiguration.Entity("sfa_caseload").Form("Information", XrmFormType.Main)
                .Field("ownerid");
        }
    }
}