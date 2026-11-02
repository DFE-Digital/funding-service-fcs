namespace SFA.FCT.Xrm.Configuration.Tests.Security_Roles
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    [TestClass]
    public class XrmConfigurationSecurityRolesContractsManager : TestBase
    {
        #region Non-Entity Roles

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "229")]
        public void ConfiguratorRoleContainsCorrectNonEntityPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ActivateBusinessProcessFlow", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ActivateBusinessRule", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ActivateSynchronousWorkflow", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ActOnBehalfOfAnotherUser", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("AddressBook", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("AdminFilter", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("AllowQuickCampaign", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ApproveRejectEmailAddress", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("BrowseAvailability", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("BulkDelete", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("BulkEdit", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ChangeSqlEncryptionKey", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ConfigureInternetMarketing", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ConfigureYammer", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("DisableBusinessUnit", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("DisableUser", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ExportCustomization", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ExportToExcel", XrmSecurityAction.NonEntity, XrmSecurityPriv.Organization)
                .HasPrivilege("GoMobile", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("GoOffline", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ImportCustomization", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ISVExtensions", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("LanguageSettings", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("MailMerge", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("Merge", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("OverrideCreatedOnCreatedBy", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("OverridePriceEngineInvoice", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("OverridePriceEngineOpportunity", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("OverridePriceEngineOrder", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("OverridePriceEngineQuote", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("Print", XrmSecurityAction.NonEntity, XrmSecurityPriv.Organization)
                .HasPrivilege("PromoteToAdmin", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("PublishArticle", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("PublishCustomization", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("PublishDuplicateRule", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("PublishOrgMailMergeTemplate", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("PublishOrgReport", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("PublishRSReport", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("QOIOverrideDelete", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ReparentBusinessUnit", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ReparentTeam", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("ReparentUser", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("RestoreSqlEncryptionKey", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("RetrieveMultipleSocialInsights", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("RollupGoal", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("SearchAvailability", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("SendAsUser", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("SendInviteForLive", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("SyncToOutlook", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("TurnDevErrorsOnOff", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("UseInternetMarketing", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("UseTabletApp", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("WebMailMerge", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
                .HasPrivilege("WorkflowExecution", XrmSecurityAction.NonEntity, XrmSecurityPriv.None);
        }

        #endregion

        #region Entity Roles

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectAccountPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Account", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Account", XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                .HasPrivilege("Account", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Account", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Account", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Account", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Account", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Account", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectActivityPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Activity", XrmSecurityAction.Create, XrmSecurityPriv.Organization)
                .HasPrivilege("Activity", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Activity", XrmSecurityAction.Write, XrmSecurityPriv.Organization)
                .HasPrivilege("Activity", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Activity", XrmSecurityAction.Assign, XrmSecurityPriv.Organization)
                .HasPrivilege("Activity", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Activity", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Activity", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectAppFilePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ApplicationFile", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ApplicationFile", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ApplicationFile", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ApplicationFile", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ApplicationFile", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ApplicationFile", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ApplicationFile", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ApplicationFile", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectArticlePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Article", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Article", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Article", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Article", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Article", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Article", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Article", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Article", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectArticleTemplatePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ArticleTemplate", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ArticleTemplate", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ArticleTemplate", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ArticleTemplate", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ArticleTemplate", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ArticleTemplate", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ArticleTemplate", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ArticleTemplate", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectAyncOperationPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("AsyncOperation", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("AsyncOperation", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("AsyncOperation", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("AsyncOperation", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("AsyncOperation", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("AsyncOperation", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("AsyncOperation", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("AsyncOperation", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectAttributePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Attribute", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Attribute", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Attribute", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Attribute", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Attribute", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Attribute", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Attribute", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Attribute", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectAttributeMapPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("AttributeMap", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("AttributeMap", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("AttributeMap", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("AttributeMap", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("AttributeMap", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("AttributeMap", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("AttributeMap", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("AttributeMap", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectAuthServerPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("AuthorizationServer", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("AuthorizationServer", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("AuthorizationServer", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("AuthorizationServer", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("AuthorizationServer", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("AuthorizationServer", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("AuthorizationServer", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("AuthorizationServer", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectBusinessUnitPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("BusinessUnit", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("BusinessUnit", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("BusinessUnit", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("BusinessUnit", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("BusinessUnit", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("BusinessUnit", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("BusinessUnit", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("BusinessUnit", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectCalendarPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Calendar", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Calendar", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Calendar", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Calendar", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Calendar", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Calendar", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Calendar", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Calendar", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectCampaignPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Campaign", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Campaign", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Campaign", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Campaign", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Campaign", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Campaign", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Campaign", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Campaign", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectCompetitorPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Competitor", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Competitor", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Competitor", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Competitor", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Competitor", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Competitor", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Competitor", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Competitor", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectComplexControlPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ComplexControl", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ComplexControl", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ComplexControl", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ComplexControl", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ComplexControl", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ComplexControl", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ComplexControl", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ComplexControl", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectConnectionPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Connection", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Connection", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Connection", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Connection", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Connection", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Connection", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Connection", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Connection", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectConnectionRolePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ConnectionRole", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ConnectionRole", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ConnectionRole", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ConnectionRole", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ConnectionRole", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ConnectionRole", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ConnectionRole", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ConnectionRole", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectContactPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Contact", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Contact", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Contact", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Contact", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Contact", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Contact", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Contact", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Contact", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectContractOobPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Contract", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Contract", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Contract", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Contract", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Contract", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Contract", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Contract", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Contract", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectContractTemplatePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ContractTemplate", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ContractTemplate", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ContractTemplate", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ContractTemplate", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ContractTemplate", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ContractTemplate", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ContractTemplate", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ContractTemplate", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectConvertRulePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ConvertRule", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ConvertRule", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ConvertRule", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ConvertRule", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ConvertRule", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ConvertRule", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ConvertRule", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ConvertRule", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectCustomerOpportunityRolePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("CustomerOpportunityRole", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("CustomerOpportunityRole", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("CustomerOpportunityRole", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("CustomerOpportunityRole", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("CustomerOpportunityRole", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("CustomerOpportunityRole", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("CustomerOpportunityRole", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("CustomerOpportunityRole", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectCustomerRelationshipPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("CustomerRelationship", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("CustomerRelationship", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("CustomerRelationship", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("CustomerRelationship", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("CustomerRelationship", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("CustomerRelationship", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("CustomerRelationship", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("CustomerRelationship", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectCustomizationPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Customization", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Customization", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Customization", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Customization", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Customization", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Customization", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Customization", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Customization", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectDuplicateRulePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("DuplicateRule", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("DuplicateRule", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("DuplicateRule", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("DuplicateRule", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("DuplicateRule", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("DuplicateRule", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("DuplicateRule", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("DuplicateRule", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectEmailServerProfilePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("EmailServerProfile", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("EmailServerProfile", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("EmailServerProfile", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("EmailServerProfile", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("EmailServerProfile", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("EmailServerProfile", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("EmailServerProfile", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("EmailServerProfile", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectEmailTemplatePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("EmailTemplate", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("EmailTemplate", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("EmailTemplate", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("EmailTemplate", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("EmailTemplate", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("EmailTemplate", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("EmailTemplate", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("EmailTemplate", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectEntitlementPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Entitlement", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Entitlement", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Entitlement", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Entitlement", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Entitlement", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Entitlement", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Entitlement", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Entitlement", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectEntitlementTemplatePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("EntitlementTemplate", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("EntitlementTemplate", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("EntitlementTemplate", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("EntitlementTemplate", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("EntitlementTemplate", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("EntitlementTemplate", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("EntitlementTemplate", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("EntitlementTemplate", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectEntityPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Entity", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Entity", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Entity", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Entity", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Entity", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Entity", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Entity", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Entity", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectEntityMapPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("EntityMap", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("EntityMap", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("EntityMap", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("EntityMap", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("EntityMap", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("EntityMap", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("EntityMap", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("EntityMap", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectEquipmentPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Equipment", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Equipment", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Equipment", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Equipment", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Equipment", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Equipment", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Equipment", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Equipment", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectExchangeSyncIdMappingPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ExchangeSyncIdMapping", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ExchangeSyncIdMapping", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ExchangeSyncIdMapping", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ExchangeSyncIdMapping", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ExchangeSyncIdMapping", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ExchangeSyncIdMapping", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ExchangeSyncIdMapping", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ExchangeSyncIdMapping", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectFieldSecurityProfilePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("FieldSecurityProfile", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("FieldSecurityProfile", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("FieldSecurityProfile", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("FieldSecurityProfile", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("FieldSecurityProfile", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("FieldSecurityProfile", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("FieldSecurityProfile", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("FieldSecurityProfile", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectGoalPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Goal", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Goal", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Goal", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Goal", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Goal", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Goal", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Goal", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Goal", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectGoalRollupQueryPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("GoalRollupQuery", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("GoalRollupQuery", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("GoalRollupQuery", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("GoalRollupQuery", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("GoalRollupQuery", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("GoalRollupQuery", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("GoalRollupQuery", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("GoalRollupQuery", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectImportPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Import", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Import", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Import", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Import", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Import", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Import", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Import", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Import", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectImportFilePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ImportFile", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ImportFile", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ImportFile", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ImportFile", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ImportFile", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ImportFile", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ImportFile", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ImportFile", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectImportMapPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ImportMap", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ImportMap", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ImportMap", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ImportMap", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ImportMap", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ImportMap", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ImportMap", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ImportMap", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectIncidentPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Incident", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Incident", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Incident", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Incident", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Incident", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Incident", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Incident", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Incident", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectInvoicePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Invoice", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Invoice", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Invoice", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Invoice", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Invoice", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Invoice", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Invoice", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Invoice", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectLeadPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Lead", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Lead", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Lead", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Lead", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Lead", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Lead", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Lead", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Lead", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectListPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("List", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("List", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("List", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("List", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("List", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("List", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("List", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("List", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectMailBoxPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Mailbox", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Mailbox", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Mailbox", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Mailbox", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Mailbox", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Mailbox", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Mailbox", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Mailbox", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectMailMergeTemplatePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("MailMergeTemplate", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("MailMergeTemplate", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("MailMergeTemplate", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("MailMergeTemplate", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("MailMergeTemplate", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("MailMergeTemplate", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("MailMergeTemplate", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("MailMergeTemplate", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectMetricPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Metric", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Metric", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Metric", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Metric", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Metric", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Metric", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Metric", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Metric", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPostAlbumPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("msdyn_PostAlbum", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostAlbum", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostAlbum", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostAlbum", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostAlbum", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostAlbum", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostAlbum", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostAlbum", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPostConfigPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("msdyn_PostConfig", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostConfig", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostConfig", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostConfig", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostConfig", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostConfig", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostConfig", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostConfig", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPostRuleConfigPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("msdyn_PostRuleConfig", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostRuleConfig", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostRuleConfig", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostRuleConfig", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostRuleConfig", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostRuleConfig", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostRuleConfig", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_PostRuleConfig", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectWallSavedQueryPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("msdyn_wallsavedquery", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedquery", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedquery", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedquery", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedquery", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedquery", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedquery", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedquery", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectWallSavedQuerySettingsPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("msdyn_wallsavedqueryusersettings", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedqueryusersettings", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedqueryusersettings", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedqueryusersettings", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedqueryusersettings", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedqueryusersettings", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedqueryusersettings", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("msdyn_wallsavedqueryusersettings", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectNewsArticlePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("NewsArticle", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("NewsArticle", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("NewsArticle", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("NewsArticle", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("NewsArticle", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("NewsArticle", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("NewsArticle", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("NewsArticle", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectNotePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Note", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Note", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Note", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Note", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Note", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Note", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Note", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Note", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectOpportunityPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Opportunity", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Opportunity", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Opportunity", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Opportunity", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Opportunity", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Opportunity", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Opportunity", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Opportunity", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectOptionSetPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("OptionSet", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("OptionSet", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("OptionSet", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("OptionSet", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("OptionSet", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("OptionSet", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("OptionSet", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("OptionSet", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectOrderPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Order", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Order", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Order", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Order", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Order", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Order", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Order", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Order", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectOrgEmailTemplatesPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("OrgEmailTemplates", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("OrgEmailTemplates", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("OrgEmailTemplates", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("OrgEmailTemplates", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("OrgEmailTemplates", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("OrgEmailTemplates", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("OrgEmailTemplates", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("OrgEmailTemplates", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectOwnCalendarPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("OwnCalendar", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("OwnCalendar", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("OwnCalendar", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("OwnCalendar", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("OwnCalendar", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("OwnCalendar", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("OwnCalendar", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("OwnCalendar", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPartnerApplicationPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("PartnerApplication", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("PartnerApplication", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("PartnerApplication", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("PartnerApplication", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("PartnerApplication", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("PartnerApplication", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("PartnerApplication", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("PartnerApplication", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPluginAssemblyPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("PluginAssembly", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("PluginAssembly", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("PluginAssembly", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("PluginAssembly", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("PluginAssembly", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("PluginAssembly", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("PluginAssembly", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("PluginAssembly", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPluginTypePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("PluginType", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("PluginType", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("PluginType", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("PluginType", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("PluginType", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("PluginType", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("PluginType", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("PluginType", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPostPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Post", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Post", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Post", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Post", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Post", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Post", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Post", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Post", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPostFollowPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("PostFollow", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("PostFollow", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("PostFollow", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("PostFollow", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("PostFollow", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("PostFollow", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("PostFollow", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("PostFollow", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPrincipleObjectAccessPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("PrincipalObjectAttributeAccess", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("PrincipalObjectAttributeAccess", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("PrincipalObjectAttributeAccess", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("PrincipalObjectAttributeAccess", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("PrincipalObjectAttributeAccess", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("PrincipalObjectAttributeAccess", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("PrincipalObjectAttributeAccess", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("PrincipalObjectAttributeAccess", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectProductPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Product", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Product", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Product", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Product", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Product", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Product", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Product", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Product", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectPublisherPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Publisher", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Publisher", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Publisher", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Publisher", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Publisher", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Publisher", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Publisher", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Publisher", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectQueryPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Query", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Query", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Query", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Query", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Query", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Query", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Query", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Query", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectQueuePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Queue", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Queue", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Queue", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Queue", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Queue", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Queue", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Queue", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Queue", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectQuotePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Quote", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Quote", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Quote", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Quote", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Quote", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Quote", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Quote", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Quote", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectRelationshipPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Relationship", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Relationship", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Relationship", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Relationship", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Relationship", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Relationship", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Relationship", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Relationship", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectRelationshipRolePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("RelationshipRole", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("RelationshipRole", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("RelationshipRole", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("RelationshipRole", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("RelationshipRole", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("RelationshipRole", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("RelationshipRole", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("RelationshipRole", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectReportPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Report", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Report", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Report", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Report", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Report", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Report", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Report", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Report", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectRolePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Role", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Role", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Role", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Role", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Role", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Role", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Role", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Role", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectRoutingRulePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("RoutingRule", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("RoutingRule", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("RoutingRule", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("RoutingRule", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("RoutingRule", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("RoutingRule", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("RoutingRule", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("RoutingRule", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSalesLiteraturePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SalesLiterature", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SalesLiterature", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SalesLiterature", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SalesLiterature", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SalesLiterature", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SalesLiterature", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SalesLiterature", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SalesLiterature", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSavedQueryVisualisationsPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SavedQueryVisualizations", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SavedQueryVisualizations", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SavedQueryVisualizations", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SavedQueryVisualizations", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SavedQueryVisualizations", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SavedQueryVisualizations", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SavedQueryVisualizations", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SavedQueryVisualizations", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSdkMessagePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SdkMessage", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessage", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessage", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessage", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessage", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessage", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessage", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessage", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSdkMessageProcessingStepPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SdkMessageProcessingStep", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStep", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStep", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStep", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStep", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStep", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStep", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStep", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSdkMessageProcessingStepImagePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SdkMessageProcessingStepImage", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepImage", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepImage", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepImage", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepImage", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepImage", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepImage", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepImage", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSdkMessageProcessingStepConfigPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SdkMessageProcessingStepSecureConfig", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepSecureConfig", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepSecureConfig", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepSecureConfig", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepSecureConfig", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepSecureConfig", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepSecureConfig", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SdkMessageProcessingStepSecureConfig", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectServicePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Service", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Service", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Service", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Service", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Service", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Service", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Service", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Service", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectServiceEndpointPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("ServiceEndpoint", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("ServiceEndpoint", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("ServiceEndpoint", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("ServiceEndpoint", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("ServiceEndpoint", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("ServiceEndpoint", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("ServiceEndpoint", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("ServiceEndpoint", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectsfa_contractPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_contract", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contract", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contract", XrmSecurityAction.Write, XrmSecurityPriv.BusinessUnit)
                .HasPrivilege("sfa_contract", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contract", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contract", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contract", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contract", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSsfa_contractransactionhistoryPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_contracttransitionhistory", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttransitionhistory", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttransitionhistory", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttransitionhistory", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttransitionhistory", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttransitionhistory", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectsfa_contracttypePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_contracttype", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttype", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttype", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttype", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttype", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_contracttype", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectsfa_fundingtypePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_fundingtype", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingtype", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingtype", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingtype", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingtype", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingtype", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectsfa_processPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_process", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_process", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_process", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_process", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_process", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_process", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectsfa_statusPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_status", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_status", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_status", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_status", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_status", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_status", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectsfa_transitionPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_transition", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_transition", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_transition", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_transition", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_transition", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("sfa_transition", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("sfa_transition", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_transition", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSharePointDataPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SharePointData", XrmSecurityAction.Create, XrmSecurityPriv.Organization)
                .HasPrivilege("SharePointData", XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                .HasPrivilege("SharePointData", XrmSecurityAction.Write, XrmSecurityPriv.Organization);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSharePointDocumentationLocationPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SharePointDocumentLocation", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SharePointDocumentLocation", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SharePointDocumentLocation", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SharePointDocumentLocation", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SharePointDocumentLocation", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SharePointDocumentLocation", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SharePointDocumentLocation", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SharePointDocumentLocation", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSharePointSitePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SharePointSite", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SharePointSite", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SharePointSite", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SharePointSite", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SharePointSite", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SharePointSite", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SharePointSite", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SharePointSite", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSitePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Site", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Site", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Site", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Site", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Site", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Site", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Site", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Site", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSlaPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SLA", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SLA", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SLA", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SLA", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SLA", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SLA", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SLA", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SLA", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSocialProfilePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SocialProfile", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SocialProfile", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SocialProfile", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SocialProfile", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SocialProfile", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SocialProfile", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SocialProfile", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SocialProfile", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSolutionPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Solution", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Solution", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Solution", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Solution", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Solution", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Solution", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Solution", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Solution", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSubjectPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Subject", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Subject", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Subject", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Subject", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Subject", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Subject", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Subject", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Subject", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSystemApplicationMetaDatarivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SystemApplicationMetadata", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SystemApplicationMetadata", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SystemApplicationMetadata", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SystemApplicationMetadata", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SystemApplicationMetadata", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SystemApplicationMetadata", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SystemApplicationMetadata", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SystemApplicationMetadata", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectSystemFormPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("SystemForm", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("SystemForm", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("SystemForm", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("SystemForm", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("SystemForm", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("SystemForm", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("SystemForm", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("SystemForm", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectTeamPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Team", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Team", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Team", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Team", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Team", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Team", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Team", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Team", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectTerritoryPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Territory", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Territory", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Territory", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Territory", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Territory", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Territory", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Territory", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("Territory", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectTraceLogPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("TraceLog", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("TraceLog", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("TraceLog", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("TraceLog", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("TraceLog", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("TraceLog", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("TraceLog", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("TraceLog", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectTransactionCurrencyPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("TransactionCurrency", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("TransactionCurrency", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("TransactionCurrency", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("TransactionCurrency", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("TransactionCurrency", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("TransactionCurrency", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("TransactionCurrency", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("TransactionCurrency", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectUserPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("User", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("User", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("User", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("User", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("User", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("User", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("User", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("User", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectUserApplicationMetaDataPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("UserApplicationMetadata", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("UserApplicationMetadata", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("UserApplicationMetadata", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("UserApplicationMetadata", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("UserApplicationMetadata", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("UserApplicationMetadata", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("UserApplicationMetadata", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("UserApplicationMetadata", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectUserEntityInstanceDataPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("UserEntityInstanceData", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityInstanceData", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityInstanceData", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityInstanceData", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityInstanceData", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityInstanceData", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityInstanceData", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityInstanceData", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectUserEntityUiSettingsPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("UserEntityUISettings", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityUISettings", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityUISettings", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityUISettings", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityUISettings", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityUISettings", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityUISettings", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("UserEntityUISettings", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectUserFormPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("UserForm", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("UserForm", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("UserForm", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("UserForm", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("UserForm", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("UserForm", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("UserForm", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("UserForm", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectUserQueryPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("UserQuery", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("UserQuery", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("UserQuery", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("UserQuery", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("UserQuery", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("UserQuery", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("UserQuery", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("UserQuery", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectUserQueryVisualisationsPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("UserQueryVisualizations", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("UserQueryVisualizations", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("UserQueryVisualizations", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("UserQueryVisualizations", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("UserQueryVisualizations", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("UserQueryVisualizations", XrmSecurityAction.Share, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectUserSettingsPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("UserSettings", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("UserSettings", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("UserSettings", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("UserSettings", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("UserSettings", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("UserSettings", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("UserSettings", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("UserSettings", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectWebResourcePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("WebResource", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("WebResource", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("WebResource", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("WebResource", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("WebResource", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("WebResource", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("WebResource", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("WebResource", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectWebWizardPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("WebWizard", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("WebWizard", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("WebWizard", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("WebWizard", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("WebWizard", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("WebWizard", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("WebWizard", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("WebWizard", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectWizardAccessPrivilegePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("WizardAccessPrivilege", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("WizardAccessPrivilege", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("WizardAccessPrivilege", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("WizardAccessPrivilege", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("WizardAccessPrivilege", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("WizardAccessPrivilege", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("WizardAccessPrivilege", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("WizardAccessPrivilege", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectWizardPagePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("WizardPage", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("WizardPage", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("WizardPage", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("WizardPage", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("WizardPage", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("WizardPage", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("WizardPage", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("WizardPage", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectWorkflowPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("Workflow", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("Workflow", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("Workflow", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("Workflow", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("Workflow", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("Workflow", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("Workflow", XrmSecurityAction.Append, XrmSecurityPriv.Organization)
                .HasPrivilege("Workflow", XrmSecurityAction.AppendTo, XrmSecurityPriv.Organization);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "228")]
        public void ContractManagerContainsCorrectWorkflowSessionPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("WorkflowSession", XrmSecurityAction.Create, XrmSecurityPriv.User)
                .HasPrivilege("WorkflowSession", XrmSecurityAction.Read, XrmSecurityPriv.User)
                .HasPrivilege("WorkflowSession", XrmSecurityAction.Write, XrmSecurityPriv.User)
                .HasPrivilege("WorkflowSession", XrmSecurityAction.Delete, XrmSecurityPriv.User)
                .HasPrivilege("WorkflowSession", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("WorkflowSession", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("WorkflowSession", XrmSecurityAction.Append, XrmSecurityPriv.User)
                .HasPrivilege("WorkflowSession", XrmSecurityAction.AppendTo, XrmSecurityPriv.User);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "810")]
        public void ContractManagerContainsCorrectCaseLoadPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_caseload", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_caseload", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_caseload", XrmSecurityAction.Write, XrmSecurityPriv.Organization)
                .HasPrivilege("sfa_caseload", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_caseload", XrmSecurityAction.Assign, XrmSecurityPriv.Organization)
                .HasPrivilege("sfa_caseload", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("sfa_caseload", XrmSecurityAction.Append, XrmSecurityPriv.Organization)
                .HasPrivilege("sfa_caseload", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void CorrectPeriodTypePrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_periodtype", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_periodtype", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_periodtype", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_periodtype", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_periodtype", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("sfa_periodtype", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("sfa_periodtype", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_periodtype", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void CorrectPeriodPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_period", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_period", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_period", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_period", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_period", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("sfa_period", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("sfa_period", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_period", XrmSecurityAction.AppendTo, XrmSecurityPriv.None);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void CorrectFundingStreamPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_fundingstream", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstream", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstream", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstream", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstream", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstream", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstream", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstream", XrmSecurityAction.AppendTo, XrmSecurityPriv.Organization);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void CorrectFundingStreamPeriodPrivs()
        {
            CrmConfiguration.SecurityRole("Contract Manager")
                .HasPrivilege("sfa_fundingstreamperiod", XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstreamperiod", XrmSecurityAction.Read, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstreamperiod", XrmSecurityAction.Write, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstreamperiod", XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstreamperiod", XrmSecurityAction.Assign, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstreamperiod", XrmSecurityAction.Share, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstreamperiod", XrmSecurityAction.Append, XrmSecurityPriv.None)
                .HasPrivilege("sfa_fundingstreamperiod", XrmSecurityAction.AppendTo, XrmSecurityPriv.Organization);
        }

        #endregion
    }
}