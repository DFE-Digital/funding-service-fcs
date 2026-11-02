namespace SFA.FCT.Xrm.Configuration.Tests.Contracts
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContracts
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractDefaultViewExists()
        {
            CrmConfiguration.Entity("sfa_contract").DefaultView();
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityDefaultViewHasCorrectFields()
        {
            CrmConfiguration.Entity("sfa_contract").DefaultView()
                .HasColumn("sfa_number")
                .HasColumn("sfa_version")
                .HasColumn("sfa_ukprn")
                .HasColumn("sfa_providername")
                .HasColumn("sfa_fundingtype")
                .HasColumn("sfa_contractstatus")
                .HasColumn("sfa_substatus")
                .HasColumn("sfa_contractvalue")
                .HasColumn("sfa_startdate")
                .HasColumn("sfa_enddate")
                .HasColumn("sfa_contractadviser")
                .HasColumn("ownerid");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityDefaultViewHasCorrectFilters()
        {
            CrmConfiguration.Entity("sfa_contract").DefaultView()
                .HasFilter("statecode", XrmFilterOperator.EqualTo, "0")
                .HasFilter("sfa_latestversion", XrmFilterOperator.EqualTo, "1")
                .HasFilter("sfa_hierarchytype", XrmFilterOperator.EqualTo, "229660000");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityDefaultViewHasCorrectSort()
        {
            CrmConfiguration.Entity("sfa_contract").DefaultView()
                .HasSortColumn("sfa_number", XrmSortOrder.Descending);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractLatestContractViewExists()
        {
            CrmConfiguration.Entity("sfa_contract").View("Latest Contracts");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityLatestContractViewHasCorrectFields()
        {
            CrmConfiguration.Entity("sfa_contract").View("Latest Contracts")
                .HasColumn("sfa_number")
                .HasColumn("sfa_version")
                .HasColumn("sfa_ukprn")
                .HasColumn("sfa_providername")
                .HasColumn("sfa_fundingtype")
                .HasColumn("sfa_contractstatus")
                .HasColumn("sfa_substatus")
                .HasColumn("sfa_contractvalue")
                .HasColumn("sfa_startdate")
                .HasColumn("sfa_enddate")
                .HasColumn("sfa_contractadviser");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityLatestContractViewHasCorrectFilters()
        {
            CrmConfiguration.Entity("sfa_contract").View("Latest Contracts")
                .HasFilter("statecode", XrmFilterOperator.EqualTo, "0")
                .HasFilter("sfa_latestversion", XrmFilterOperator.EqualTo, "1");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityLatestContractViewHasCorrectSort()
        {
            CrmConfiguration.Entity("sfa_contract").View("Latest Contracts")
                .HasSortColumn("sfa_number", XrmSortOrder.Descending);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "71")]
        public void ContractEntityQuickSearchViewExists()
        {
            CrmConfiguration.Entity("sfa_contract").QuickView();
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "71")]
        public void ContractEntityQuickSearchViewHasCorrectColumns()
        {
            CrmConfiguration.Entity("sfa_contract").QuickView()
                .HasColumn("sfa_number")
                .HasColumn("sfa_version")
                .HasColumn("sfa_ukprn")
                .HasColumn("sfa_providername")
                .HasColumn("sfa_fundingtype")
                .HasColumn("sfa_contractstatus")
                .HasColumn("sfa_substatus")
                .HasColumn("sfa_contractvalue")
                .HasColumn("sfa_startdate")
                .HasColumn("sfa_enddate")
                .HasColumn("sfa_contractadviser");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "71")]
        public void ContractEntityQuickSearchHasCorrectFilters()
        {
            CrmConfiguration.Entity("sfa_contract").QuickView()
                .HasFilter("statecode", XrmFilterOperator.EqualTo, "0")
                .HasFilter("sfa_latestversion", XrmFilterOperator.EqualTo, "1");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "71")]
        public void ContractEntityQuickSearchHasCorrectSearchFields()
        {
            CrmConfiguration.Entity("sfa_contract").QuickView()
                .HasSearchField("sfa_providername")
                .HasSearchField("sfa_number")
                .HasSearchField("sfa_ukprn");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "71")]
        public void ContractEntityQuickSearchHasCorrectSortColumns()
        {
            CrmConfiguration.Entity("sfa_contract").QuickView()
                .HasSortColumn("sfa_number", XrmSortOrder.Descending);
        }
    }
}