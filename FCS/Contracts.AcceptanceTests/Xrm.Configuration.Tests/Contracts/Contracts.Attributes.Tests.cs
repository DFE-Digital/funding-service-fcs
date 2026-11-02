namespace SFA.FCT.Xrm.Configuration.Tests.Contracts
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContracts
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityContainsContractVersion()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_version").HasType(XrmDataType.WholeNumber);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityContainsStartDate()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_startdate").HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityContainsEndDate()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_enddate").HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityContainsContractStatus()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_contractstatus").HasType(XrmDataType.OptionSet);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityContainsContractNumber()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_number")
                .HasType(XrmDataType.Text)
                .OfLength(20)
                .HasDisplayName("Contract No");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void ContractEntityContainsUkprn()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_ukprn")
                .HasType(XrmDataType.Text)
                .HasDisplayName("UKPRN");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractEntityContainsDescription()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_description")
                .HasType(XrmDataType.Text)
                .OfLength(100)
                .HasDisplayName("Contract Description");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractEntityContainsContractValue()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_contractvalue")
                .HasType(XrmDataType.Money)
                .HasDisplayName("Contract Value");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "572")]
        public void ContractEntityContainsAmendmentType()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_amendmenttype")
                .HasType(XrmDataType.OptionSet)
                .HasDisplayName("Amendment Type");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "572")]
        public void ContractEntityContainsVariation()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_variation")
                .HasType(XrmDataType.Decimal)
                .HasDisplayName("Variation");
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "7861")]
        public void ContractEntityContainsContractApprovalDate()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_contractapprovaldate").HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "7861")]
        public void ContractEntityContainsStatusLastUpdatedDate()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_statuslastupdateddate").HasType(XrmDataType.DateTime);
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "9681")]
        public void ContractEntityContainsServiceResponse()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_serviceresponse")
                .HasType(XrmDataType.OptionSet)
                .HasDisplayName("Service Response"); 
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "9681")]
        public void ContractEntityContainsIntent()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_intent")
                .HasType(XrmDataType.Text)
                .OfLength(100)
                .HasDisplayName("Intent");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "9681")]
        public void ContractEntityContainsReason()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Attribute("sfa_reasonforrejection")
                .HasType(XrmDataType.Memo)
                .HasDisplayName("Reason");
        }
    }
}