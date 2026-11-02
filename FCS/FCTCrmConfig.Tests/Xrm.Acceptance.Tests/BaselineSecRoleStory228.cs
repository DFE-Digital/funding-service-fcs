using System;
using Ciber.Xrm.Tests;
using FCTCrmConfig.AcceptanceTests;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace FCTCrmConfig.AcceptanceTests
{
    [TestClass]
    public class BaselineSecRoleStory228
    {
        #region Constants

        private const string articleLogicalName = "Article";
        private const string calendarLogicalName = "Calendar";
        private const string campaignLogicalName = "Campaign";
        private const string competitorLogicalName = "Competitor";
        private const string connectionLogicalName = "Connection";
        private const string connectionroleLogicalName = "ConnectionRole";
        private const string contactLogicalName = "Contact";
        private const string contractLogicalName = "Contract";
        private const string contracttemplateLogicalName = "ContractTemplate";
        private const string emailserverprofileLogicalName = "EmailServerProfile";
        private const string emailtemplateLogicalName = "EmailTemplate";
        private const string entitlementLogicalName = "Entitlement";
        private const string entitlementtemplateLogicalName = "EntitlementTemplate";
        private const string equipmentLogicalName = "Equipment";
        private const string fieldsecurityprofileLogicalName = "FieldSecurityProfile";
        private const string goalLogicalName = "Goal";
        private const string goalrollupqueryLogicalName = "GoalRollupQuery";
        private const string importLogicalName = "Import";
        private const string importmapLogicalName = "ImportMap";
        private const string incidentLogicalName = "Incident";
        private const string invoiceLogicalName = "Invoice";
        private const string leadLogicalName = "Lead";
        private const string listLogicalName = "List";
        private const string mailboxLogicalName = "Mailbox";
        private const string mailmergetemplateLogicalName = "MailMergeTemplate";
        private const string metricLogicalName = "Metric";
        private const string msdyn_postalbumLogicalName = "msdyn_PostAlbum";
        private const string msdyn_postconfigLogicalName = "msdyn_PostConfig";
        private const string msdyn_postruleconfigLogicalName = "msdyn_PostRuleConfig";
        private const string msdyn_wallsavedqueryLogicalName = "msdyn_wallsavedquery";
        private const string msdyn_wallsavedqueryusersettingsLogicalName = "msdyn_wallsavedqueryusersettings";
        private const string newsarticleLogicalName = "NewsArticle";
        private const string opportunityLogicalName = "Opportunity";
        private const string orderLogicalName = "Order";
        private const string pluginassemblyLogicalName = "PluginAssembly";
        private const string pluginTypeLogicalName = "PluginType";
        private const string postLogicalName = "Post";
        private const string productLogicalName = "Product";
        private const string publisherLogicalName = "Publisher";
        private const string queueLogicalName = "Queue";
        private const string quoteLogicalName = "Quote";
        private const string relationshipLogicalName = "Relationship";
        private const string reportLogicalName = "Report";
        private const string salesliteratureLogicalName = "SalesLiterature";
        private const string sharepointdocumentlocationLogicalName = "SharePointDocumentLocation";
        private const string sharepointsiteLogicalName = "SharePointSite";
        private const string siteLogicalName = "Site";
        private const string slaLogicalName = "SLA";
        private const string socialprofileLogicalName = "SocialProfile";
        private const string solutionLogicalName = "Solution";
        private const string subjectLogicalName = "Subject";
        private const string territoryLogicalName = "Territory";
        private const string tracelogLogicalName = "TraceLog";
        private const string workflowLogicalName = "Workflow";

        #endregion

        #region BaseRoleTests
        //Confirm Required entities are available
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnContract()
        {
            TestBase.CrmConfiguration.Entity("Contract");

            var contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            TestBase.Connection.Role("Base Role")
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnTask()
        {
            TestBase.CrmConfiguration.Entity("Task");
            var tasksLogicalName = "Activity";

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnAccount()
        {
            TestBase.CrmConfiguration.Entity("Organisation");

            var accountLogicalName = "Account";

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnActivity()
        {
            var activityLogicalName = "Activity";

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnBusinessUnit()
        {
            var bussinessUnitLogicalName = "BusinessUnit";

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(bussinessUnitLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(bussinessUnitLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(bussinessUnitLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(bussinessUnitLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnNote()
        {
            TestBase.CrmConfiguration.Entity("Note");

            var noteLogicalName = "Note";

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnSfa_contracttransitionhistory()
        {
            TestBase.CrmConfiguration.Entity("sfa_contracttransitionhistory");

            var sfa_contracttransitionhistorytLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttransitionhistory").LogicalName;

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnSfa_contracttype()
        {
            TestBase.CrmConfiguration.Entity("sfa_contracttype");

            var sfa_contracttypeLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttype").LogicalName;

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnSfa_fundingtype()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingtype");

            var sfa_fundingtypeLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttype").LogicalName;

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnSfa_process()
        {
            TestBase.CrmConfiguration.Entity("sfa_process");

            var sfa_processLogicalName = TestBase.CrmConfiguration.Entity("sfa_process").LogicalName;

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }


        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnSfa_status()
        {
            TestBase.CrmConfiguration.Entity("sfa_status");

            var sfa_statusLogicalName = TestBase.CrmConfiguration.Entity("sfa_status").LogicalName;

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckBaseRoleHasReadOnlyAccessOnSfa_transition()
        {
            TestBase.CrmConfiguration.Entity("sfa_transition");

            var sfa_transitionLogicalName = TestBase.CrmConfiguration.Entity("sfa_transition").LogicalName;

            TestBase.Connection.Role("Base Role")
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.User)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        //Confirm Non-Required entities are NOT available
        public void CheckBaseRoleHasNoAccessToUnrequiredEntities()
        {
            TestBase.Connection.Role("Base Role")
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(campaignLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(campaignLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(campaignLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postalbumLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postalbumLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postalbumLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(articleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(competitorLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(connectionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(connectionroleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contracttemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(emailserverprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(emailtemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(entitlementLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(entitlementtemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(equipmentLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(goalLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(goalrollupqueryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(importLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(importmapLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(incidentLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(invoiceLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(listLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(mailboxLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(mailmergetemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(metricLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postconfigLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postruleconfigLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_wallsavedqueryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_wallsavedqueryusersettingsLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(newsarticleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(orderLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(postLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(productLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(queueLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(quoteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(relationshipLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(reportLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(sharepointdocumentlocationLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(sharepointsiteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(siteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(slaLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(socialprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(solutionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(subjectLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(territoryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(tracelogLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(workflowLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None);
        }

        #endregion

        #region Contract Adviser Tests

        //Confirm Required entities are available
        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnContract()
        {
            TestBase.CrmConfiguration.Entity("Contract");

            var contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnTask()
        {
            TestBase.CrmConfiguration.Entity("Task");
            var tasksLogicalName = "activity";

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnAccount()
        {
            TestBase.CrmConfiguration.Entity("Organisation");

            var accountLogicalName = TestBase.CrmConfiguration.Entity("Organisation").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnActivity()
        {
            var activityLogicalName = "Activity";

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnBusinessUnit()
        {
            var bussinessUnitLogicalName = TestBase.CrmConfiguration.Entity("Business Unit").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(bussinessUnitLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(bussinessUnitLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(bussinessUnitLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(bussinessUnitLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnNote()
        {
            TestBase.CrmConfiguration.Entity("Note");

            var noteLogicalName = "Note";

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnSfa_contracttransitionhistory()
        {
            TestBase.CrmConfiguration.Entity("sfa_contracttransitionhistory");

            var sfa_contracttransitionhistorytLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttransitionhistory").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnSfa_contracttype()
        {
            TestBase.CrmConfiguration.Entity("sfa_contracttype");

            var sfa_contracttypeLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttype").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnSfa_fundingtype()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingtype");

            var sfa_fundingtypeLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttype").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnSfa_process()
        {
            TestBase.CrmConfiguration.Entity("sfa_process");

            var sfa_processLogicalName = TestBase.CrmConfiguration.Entity("sfa_process").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }


        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnSfa_status()
        {
            TestBase.CrmConfiguration.Entity("sfa_status");

            var sfa_statusLogicalName = TestBase.CrmConfiguration.Entity("sfa_status").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractAdvisorHasReadOnlyAccessOnSfa_transition()
        {
            TestBase.CrmConfiguration.Entity("sfa_transition");

            var sfa_transitionLogicalName = TestBase.CrmConfiguration.Entity("sfa_transition").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.User)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        //Confirm Non-Required entities are NOT available
        public void CheckContractAdvisorHasNoAccessToUnrequiredEntities()
        {
            TestBase.Connection.Role("Contract Adviser")
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(campaignLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(campaignLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(campaignLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postalbumLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postalbumLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postalbumLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(articleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(competitorLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(connectionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(connectionroleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contracttemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(emailserverprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(emailtemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(entitlementLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(entitlementtemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(equipmentLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(goalLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(goalrollupqueryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(importLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(importmapLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(incidentLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(invoiceLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(listLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(mailboxLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(mailmergetemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(metricLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postconfigLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postruleconfigLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_wallsavedqueryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_wallsavedqueryusersettingsLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(newsarticleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(orderLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(postLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(productLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(queueLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(quoteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(relationshipLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(reportLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(sharepointdocumentlocationLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(sharepointsiteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(siteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(slaLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(socialprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(solutionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(subjectLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(territoryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(tracelogLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(workflowLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None);
        }

        #endregion

        #region Contract Manager Tests

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnContract()
        {
            TestBase.CrmConfiguration.Entity("Contract");

            var contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.Organization);

        }

        
        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnTask()
        {
            var tasksLogicalName = "activity";

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(tasksLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnAccount()
        {
            var accountLogicalName = TestBase.CrmConfiguration.Entity("Organisation").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(accountLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnActivity()
        {
            var activityLogicalName = "Activity";

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(activityLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnBusinessUnit()
        {
            var businessUnitLogicalName = "BusinessUnit";

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(businessUnitLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(businessUnitLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(businessUnitLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(businessUnitLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnNote()
        {
            var noteLogicalName = "Note";

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.User)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(noteLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnSfa_contract()
        {
            TestBase.CrmConfiguration.Entity("sfa_contract");

            var sfa_contractLogicalName = TestBase.CrmConfiguration.Entity("sfa_contract").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(sfa_contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_contractLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contractLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contractLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnSfa_contracttransitionhistory()
        {
            TestBase.CrmConfiguration.Entity("sfa_contracttransitionhistory");

            var sfa_contracttransitionhistorytLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttransitionhistory").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttransitionhistorytLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnSfa_contracttype()
        {
            TestBase.CrmConfiguration.Entity("sfa_contracttype");

            var sfa_contracttypeLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttype").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_contracttypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnSfa_fundingtype()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingtype");

            var sfa_fundingtypeLogicalName = TestBase.CrmConfiguration.Entity("sfa_contracttype").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_fundingtypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnSfa_process()
        {
            TestBase.CrmConfiguration.Entity("sfa_process");

            var sfa_processLogicalName = TestBase.CrmConfiguration.Entity("sfa_process").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_processLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }


        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnSfa_status()
        {
            TestBase.CrmConfiguration.Entity("sfa_status");

            var sfa_statusLogicalName = TestBase.CrmConfiguration.Entity("sfa_status").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_statusLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        public void CheckContractManagerHasReadOnlyAccessOnSfa_transition()
        {
            TestBase.CrmConfiguration.Entity("sfa_transition");

            var sfa_transitionLogicalName = TestBase.CrmConfiguration.Entity("sfa_transition").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.User)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                            .HasPrivilege(sfa_transitionLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None);

        }

        //[TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "228")]
        //Confirm Non-Required entities are NOT available for Contract Manager
        public void CheckContractManagerHasNoAccessToUnrequiredEntities()
        {
            TestBase.Connection.Role("Contract Manager")
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(calendarLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(fieldsecurityprofileLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(salesliteratureLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(pluginassemblyLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(pluginTypeLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(publisherLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                    .HasPrivilege(leadLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.None)
                    .HasPrivilege(articleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(competitorLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(connectionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(connectionroleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contactLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(campaignLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(contracttemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(emailserverprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(emailtemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(entitlementLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(entitlementtemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(equipmentLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(goalLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(goalrollupqueryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(importLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(importmapLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(incidentLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(invoiceLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(listLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(mailboxLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(mailmergetemplateLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(metricLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postalbumLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postconfigLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_postruleconfigLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_wallsavedqueryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(msdyn_wallsavedqueryusersettingsLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(newsarticleLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(opportunityLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(orderLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(postLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(productLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(queueLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(quoteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(relationshipLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(reportLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(sharepointdocumentlocationLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(sharepointsiteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(siteLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(slaLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(socialprofileLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(solutionLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(subjectLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(territoryLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(tracelogLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None)
                    .HasPrivilege(workflowLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.None);
        }

        #endregion
    }
}


