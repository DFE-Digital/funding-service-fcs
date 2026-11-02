namespace FCTCrmConfig.Tests
{
    using System;
    using System.Configuration;
    using System.Data;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Ciber.Xrm.Tests.MetaData;

    [TestClass]
    public class CrmAttribute_Tests
    {

        private XrmConfiguration CrmConfiguration;

        [TestInitialize()]
        public void InitializeConfig()
        {
            //this.CrmConfiguration = new XrmWebConfiguration(Properties.Settings.Default.CrmConnectionString);
            this.CrmConfiguration = new XrmPackageConfiguration(Properties.Settings.Default.SolutionPackagePath);

        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsContractVersion()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_version")
                                                            .HasType(XrmDataType.WholeNumber)
                                                            .IsValidForAdvancedFind(); 
        }




        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsContractValue()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_contractvalue")
                                                            .HasType(XrmDataType.Money)
                                                            .IsValidForAdvancedFind();
        }


        
        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsLatestVersion()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_latestversion")
                                                            .HasType(XrmDataType.TwoOptions)
                                                            .IsValidForAdvancedFind();
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsLastApprovedVersion()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_lastapprovedversion")
                                                            .HasType(XrmDataType.TwoOptions)
                                                            .IsValidForAdvancedFind();
        }
        
  

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsStartDate()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_startdate")
                                                            .HasType(XrmDataType.DateTime)
                                                            .IsValidForAdvancedFind(); 
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsdescription()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_description")
                                                            .HasType(XrmDataType.Text)
                                                            .IsValidForAdvancedFind(); 
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsEndDate()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_enddate")
                                                            .HasType(XrmDataType.DateTime)
                                                            .IsValidForAdvancedFind(); 
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsContractStatus()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_contractstatus")
                                                            .HasType(XrmDataType.OptionSet)
                                                            .IsValidForAdvancedFind(); ;

        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsContractDocumentation()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_documentation")
                                                            .HasType(XrmDataType.Text);
                                                            
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsContractNumber()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_number")
                                                            .HasType(XrmDataType.Text)
                                                            .OfLength(12)
                                                            .IsValidForAdvancedFind();;

            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_number")
                                                         .HasType(XrmDataType.Text)
                                                         .HasDisplayName("Contract No")
                                                         .IsValidForAdvancedFind(); ;
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Attributes")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractEntityContainsUKPRN()
        {
            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_ukprn")
                                                            .HasType(XrmDataType.Text);

            this.CrmConfiguration.Entity("sfa_contract").Attribute("sfa_ukprn")
                                                            .HasType(XrmDataType.Text)
                                                            .HasDisplayName("UKPRN")
                                                            .IsValidForAdvancedFind(); ;

        }


    }
}
