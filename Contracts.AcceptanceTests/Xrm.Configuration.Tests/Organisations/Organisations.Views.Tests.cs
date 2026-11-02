using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests.Contracts
{
    public partial class XrmConfigurationContracts : TestBase
    {
       [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        public void CaseloadDefaultViewHasCorrectFields()
       {
           TestBase.CrmConfiguration.Entity("sfa_caseload").DefaultView()
               .HasColumn("sfa_ukprn")
               .HasColumn("sfa_organisationname")
               .HasColumn("ownerid")
               .HasColumn("createdon")
               .HasColumn("sfa_status");
       }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the default view have the correct filters
        public void CaseloadEntityDefaultViewHasCorrectFilters()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").DefaultView()
                .HasFilter("statecode", XrmFilterOperator.EqualTo, "0");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the default view have the correct sort order
        public void CaseloadEntityDefaultViewHasCorrectSort()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").DefaultView()
                .HasSortColumn("sfa_status", XrmSortOrder.Ascending)
                .HasSortColumn("sfa_organisationname", XrmSortOrder.Ascending);
        }
        
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the Latest Contract view have the correct columns
        public void CaseloadEntityLatestUnassignedViewHasCorrectFields()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").View("Unassigned Caseloads")
                .HasColumn("sfa_ukprn")
                .HasColumn("sfa_organisationname")
                .HasColumn("createdon")
                .HasColumn("sfa_status");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the Latest Contract view have the correct filters
        public void CaseloadEntityUnassignedViewHasCorrectFilters()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").View("Unassigned Caseloads")
                .HasFilter("name", XrmFilterOperator.EqualTo, "Unassigned", TestBase.CrmConfiguration.Entity("team"));
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the Latest Contract view have the correct sort order
        public void CaseloadEntityUnassignedViewHasCorrectSortOrder()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").View("Unassigned Caseloads")
                .HasSortColumn("sfa_status", XrmSortOrder.Ascending)
                .HasSortColumn("sfa_organisationname", XrmSortOrder.Ascending);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the quick search view have the correct columns
        public void CaseloadEntityQuickSearchViewHasCorrectColumns()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").QuickView()
               .HasColumn("sfa_ukprn")
               .HasColumn("sfa_organisationname")
               .HasColumn("ownerid")
               .HasColumn("createdon")
               .HasColumn("sfa_status");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the quick search view have the correct filters
        public void CaseloadEntityQuickSearchHasCorrectFilters()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").QuickView()
                .HasFilter("statecode", XrmFilterOperator.EqualTo, "0");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the quick search view have the correct find columns
        public void CaseloadEntityQuickSearchHasCorrectSearchFields()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").QuickView()
                    .HasSearchField("sfa_organisationname")
                    .HasSearchField("ownerid")
                    .HasSearchField("sfa_ukprn");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "1227")]
        //Does the quick search view have the correct column sort order
        public void CaseloadEntityQuickSearchHasCorrectSortColumns()
        {
            TestBase.CrmConfiguration.Entity("sfa_caseload").QuickView()
                .HasSortColumn("sfa_status", XrmSortOrder.Ascending)
                .HasSortColumn("sfa_organisationname", XrmSortOrder.Ascending);
        }
    }
}

