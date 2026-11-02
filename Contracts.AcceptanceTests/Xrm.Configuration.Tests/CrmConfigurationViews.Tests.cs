namespace FCTCrmConfig.Tests
{
    using System;
    using System.Configuration;
    using System.Data;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Ciber.Xrm.Tests.MetaData;

    [TestClass]
    public class CrmViews_Tests
    {
        private XrmConfiguration CrmConfiguration;

        [TestInitialize()]
        public void InitializeConfig()
        {
            //this.CrmConfiguration = new XrmWebConfiguration(Properties.Settings.Default.CrmConnectionString);
            this.CrmConfiguration = new XrmPackageConfiguration(Properties.Settings.Default.SolutionPackagePath);
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractAdvancedFindViewExists()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridContractNumber()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_number");
        }
        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridUkprn()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_ukprn");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridProviderName()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_providername");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridFundingType()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_fundingtype");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridContractVersion()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_version");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridContractStatus()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_contractstatus");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridSubstatus()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_substatus");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridContractStartDate()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_startdate");

        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridContractEnddate()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_enddate");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridContractValue()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("sfa_contractvalue");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityAdvanceSearchGridContractOwner()
        {
            this.CrmConfiguration.Entity("sfa_contract").View("Contract Advanced Find View")
                                                        .HasColumn("ownerid");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridContractNumber()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasColumn("sfa_number");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridUkprn()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasColumn("sfa_ukprn");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridProviderName()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasLinkedColumn("sfa_providername");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridFundingType()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasLinkedColumn("sfa_fundingtype");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridContractVersion()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasColumn("sfa_version");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridContractStatus()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasColumn("sfa_contractstatus");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridContractSubstatus()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasLinkedColumn("sfa_substatus");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchContractStartDate()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasColumn("sfa_startdate");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridContractEndDate()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasColumn("sfa_enddate");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchGridContractOwner()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasLinkedColumn("owninguser");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchFieldProviderName()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasLinkedColumn("sfa_providername");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchFieldContractUkprn()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasColumn("sfa_ukprn");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchFieldContractNumber()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasColumn("sfa_number");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchHasCorrectFilters()
        {
            this.CrmConfiguration.Entity("Contract").QuickView()//.HasFilter("Status", XrmFilterOperator.EqualTo, "Active");
             .HasFilter("sfa_latestversion", XrmFilterOperator.EqualTo, "1");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchHasCorrectSearchFields()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasSearchField("sfa_providername")
                                                                    .HasSearchField("sfa_number")
                                                                    .HasSearchField("sfa_ukprn");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Contract")]
        public void ContractEntityQuickSearchHasCorrectSortColumns()
        {
            this.CrmConfiguration.Entity("sfa_contract").QuickView().HasSortColumn("sfa_number", XrmSortOrder.Descending);
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Contract View")]
        public void ContractEntityQuickSearchHasColumnByName()
        {
            this.CrmConfiguration.Entity("Contract").QuickView().HasColumn("Contract Status");
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Views")]
        [TestProperty("Initial_Story", "Quick Search for a Tasks")]
        public void TaskEntityQuickSearchHasCorrectSearchFields()
        {
            this.CrmConfiguration.Entity("task").QuickView()
                                                                    .HasSearchField("sfa_provider")
                                                                    .HasSearchField("regardingobjectid")
                                                                    .HasSortColumn("regardingobjectid", XrmSortOrder.Descending);
                                                                    
        }

    }
}
