namespace FCTCrmConfig.Tests
{
    using System;
    using System.Configuration;
    using System.Data;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Ciber.Xrm.Tests.MetaData;

    [TestClass]
    public class CrmRelationship_Tests
    {

        private XrmConfiguration CrmConfiguration;

        [TestInitialize()]
        public void InitializeConfig()
        {
            //this.CrmConfiguration = new XrmWebConfiguration(Properties.Settings.Default.CrmConnectionString);
            this.CrmConfiguration = new XrmPackageConfiguration(Properties.Settings.Default.SolutionPackagePath);

        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Relationships")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ProviderHasChildContract()
        {
            this.CrmConfiguration.Entity("account").Relationship("sfa_contract")
                                                            .HasFieldName("sfa_providername")
                                                            .HasDisplayName("Provider")
                                                            .IsAvailableForAdvanceFind(true)
                                                            .HasRequiredLevel(XrmRequirementLevel.None);
                                                            

        }


        [TestMethod]
        [TestCategory("CRM_Configuration.Relationships")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractrHasChildContract()
        {
            this.CrmConfiguration.Entity("sfa_contract").Relationship("sfa_contract")
                                                            .HasFieldName("sfa_previousversion")
                                                            .HasDisplayName("Previous Version")
                                                            .IsAvailableForAdvanceFind(true)
                                                            .HasRequiredLevel(XrmRequirementLevel.None);
            
                                                            
        }




        [TestMethod]
        [TestCategory("CRM_Configuration.Relationships")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void ContractTypeHasChildContract()
        {
            this.CrmConfiguration.Entity("sfa_contracttype").Relationship("sfa_contract")
                                                            .HasFieldName("sfa_contracttype")
                                                            .HasDisplayName("Contract Type")
                                                            .IsAvailableForAdvanceFind(true)
                                                            .HasRequiredLevel(XrmRequirementLevel.BusinessRequired);

        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Relationships")]
        [TestProperty("Initial_Story", "Advanced Search for a Contract")]
        public void FundingTypeHasChildContract()
        {
            this.CrmConfiguration.Entity("sfa_fundingtype").Relationship("sfa_contract")
                                                            .HasFieldName("sfa_fundingtype")
                                                            .HasDisplayName("Funding Type")
                                                            .IsAvailableForAdvanceFind(true)
                                                            .HasRequiredLevel(XrmRequirementLevel.BusinessRequired);

        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Relationships")]
        [TestProperty("Initial_Story", "Confirm Draft Contract Ready for Approval")]
        public void ProcessHasChildStatus()
        {
            this.CrmConfiguration.Entity("sfa_process").Relationship("sfa_status")
                                                        .HasFieldName("sfa_process")
                                                        .HasDisplayName("Process")
                                                        .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Relationships")]
        [TestProperty("Initial_Story", "Confirm Draft Contract Ready for Approval")]
        public void StatusHasChildTransition()
        {
            this.CrmConfiguration.Entity("sfa_status").Relationship("sfa_transition")
                                                        .HasFieldName("sfa_fromaction")
                                                        .HasDisplayName("From Action")
                                                        .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Relationships")]
        [TestProperty("Initial_Story", "Confirm Draft Contract Ready for Approval")]
        public void TransitionHasChildContract()
        {
            this.CrmConfiguration.Entity("sfa_transition").Relationship("sfa_contract")
                                                        .HasFieldName("sfa_nextaction")
                                                        .HasDisplayName("Next Action")
                                                        .HasRequiredLevel(XrmRequirementLevel.None);
        }

        [TestMethod]
        [TestCategory("CRM_Configuration.Relationships")]
        [TestProperty("Initial_Story", "Confirm Draft Contract Ready for Approval")]
        public void StatusHasChildContract()
        {
            this.CrmConfiguration.Entity("sfa_status").Relationship("sfa_contract")
                                                        .HasFieldName("sfa_substatus")
                                                        .HasDisplayName("Sub Status")
                                                        .IsAvailableForAdvanceFind(true)
                                                        .HasRequiredLevel(XrmRequirementLevel.None);
        }

        }
    }

