using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.Xrm.Configuration.Tests.Security_Roles
{


    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;


    [TestClass]
    public class SecurityRoles : TestBase
    {
        #region Non-Entity Roles

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "15012")]
        public void  ClaimEditorContainsCorrectNonEntityPrivs()
        {
            CrmConfiguration.SecurityRole("Claim Editor")
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
                .HasPrivilege("Print", XrmSecurityAction.NonEntity, XrmSecurityPriv.None)
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
        [TestProperty("StoryNo", "15012")]
        public void ClaimEditorContainsCorrectImportPrivs()
        {
            CrmConfiguration.SecurityRole("Claim Editor")
                .HasPrivilege("Import", XrmSecurityAction.Create, XrmSecurityPriv.Organization)
                .HasPrivilege("Import", XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                .HasPrivilege("Import", XrmSecurityAction.Write, XrmSecurityPriv.Organization)
                .HasPrivilege("Import", XrmSecurityAction.Delete, XrmSecurityPriv.User)
                .HasPrivilege("Import", XrmSecurityAction.Assign, XrmSecurityPriv.Organization)
                .HasPrivilege("Import", XrmSecurityAction.Share, XrmSecurityPriv.Organization)
                .HasPrivilege("Import", XrmSecurityAction.Append, XrmSecurityPriv.Organization)
                .HasPrivilege("Import", XrmSecurityAction.AppendTo, XrmSecurityPriv.Organization);
        }

        #endregion


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "15012")]
        public void ClaimEditorContainsCorrectImportFilePrivs()
        {
            CrmConfiguration.SecurityRole("Claim Editor")
                .HasPrivilege("ImportFile", XrmSecurityAction.Create, XrmSecurityPriv.User)
                .HasPrivilege("ImportFile", XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                .HasPrivilege("ImportFile", XrmSecurityAction.Write, XrmSecurityPriv.User)
                .HasPrivilege("ImportFile", XrmSecurityAction.Delete, XrmSecurityPriv.User)
                .HasPrivilege("ImportFile", XrmSecurityAction.Assign, XrmSecurityPriv.User)
                .HasPrivilege("ImportFile", XrmSecurityAction.Share, XrmSecurityPriv.ParentChildBusinessUnit)
                .HasPrivilege("ImportFile", XrmSecurityAction.Append, XrmSecurityPriv.User)
                .HasPrivilege("ImportFile", XrmSecurityAction.AppendTo, XrmSecurityPriv.User);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "15012")]
        public void ClaimEditorContainsCorrectImportMapPrivs()
        {
            CrmConfiguration.SecurityRole("Claim Editor")
                .HasPrivilege("ImportMap", XrmSecurityAction.Create, XrmSecurityPriv.Organization)
                .HasPrivilege("ImportMap", XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                .HasPrivilege("ImportMap", XrmSecurityAction.Write, XrmSecurityPriv.Organization)
                .HasPrivilege("ImportMap", XrmSecurityAction.Delete, XrmSecurityPriv.User)
                .HasPrivilege("ImportMap", XrmSecurityAction.Assign, XrmSecurityPriv.Organization)
                .HasPrivilege("ImportMap", XrmSecurityAction.Share, XrmSecurityPriv.Organization)
                .HasPrivilege("ImportMap", XrmSecurityAction.Append, XrmSecurityPriv.Organization)
                .HasPrivilege("ImportMap", XrmSecurityAction.AppendTo, XrmSecurityPriv.Organization);
        }
    }
}
