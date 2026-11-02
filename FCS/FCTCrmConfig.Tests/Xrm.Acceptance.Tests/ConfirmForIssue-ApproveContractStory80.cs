using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class ConfirmForIssueApproveContractStory80
    {
        private DateTime testStartDateTime = DateTime.Now;
        private string contractNumber = "TST-8000080";
        private string contractAdviserName = "Sarah Smith";
        private string contractManagerName = "Grace Green";

        [TestInitialize]
        public void TestSetup()
        {
            var contract = TestBase.CrmConfiguration.Entity("Contract");
            var substatus = TestBase.CrmConfiguration.Entity("Status");
            var org = TestBase.CrmConfiguration.Entity("Organisation");
            var fundingType = TestBase.CrmConfiguration.Entity("Funding Type");
            var systemUser = TestBase.CrmConfiguration.Entity("User");

            var substatusId = TestBase.Connection.GetRecord(substatus, "In Review");
            var providerId = TestBase.Connection.GetRecord(org, "NELSON AND COLNE COLLEGE");
            var fundingTypeId = TestBase.Connection.GetRecord(fundingType, "Apprenticeship Grant for Employers");
            var contractAdviser = TestBase.Connection.GetRecord(systemUser, contractAdviserName, "FullName");
            var transition = TestBase.CrmConfiguration.Entity("Transition");
            var transitionRecordRelease = TestBase.Connection.GetRecord(transition, "Release for Internal Approval");

            TestBase.Connection
                .SetRecord(contract, contractNumber)
                .SetField("Version", 1)
                .SetField("Latest Version", true)
                .SetField("Description", "Test Description")
                .SetField("Contract Value", 1234)
                .SetField("UKPRN", 98769876)
                .SetField("Start Date", testStartDateTime)
                .SetField("Contract Status", "Draft")
                .SetLookupField(fundingType, "Funding Type", fundingTypeId)
                .SetLookupField(org, "Provider", providerId)
                .SetLookupField(substatus, "Sub Status", substatusId)
                .SetLookupField(systemUser, "Contract Owner", contractAdviser)
                .SetLookupField(systemUser, "Owning User", contractAdviser) //Task Owner
                .Create();

            TestBase.ConnectAsUser(contractAdviserName)
             .GetRecord(contract, contractNumber)
             .SetLookupField(systemUser, "Modified By", contractAdviser)
             .SetLookupField(transition, "Next Action", transitionRecordRelease)
             .Update();
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "80")]
        public void TestContractManagerApproveProcess()
        {
            var contract = TestBase.CrmConfiguration.Entity("Contract");
            var substatus = TestBase.CrmConfiguration.Entity("Status");
            var systemUser = TestBase.CrmConfiguration.Entity("User");
            var workflowHistory = TestBase.CrmConfiguration.Entity("Workflow History");
            var task = TestBase.CrmConfiguration.Entity("Task");

            var transition = TestBase.CrmConfiguration.Entity("Transition");
            var transitionRecordApprove = TestBase.Connection
                .GetRecord(transition, "Approve For Issue");

            var contractRecord = TestBase.ConnectAsUser(contractManagerName)
                 .GetRecord(contract, contractNumber)
                 .LookupFieldValueEquals(substatus, "Sub Status", "Awaiting Internal Approval")
                 .SetLookupField(transition, "Next Action", transitionRecordApprove)
                 .Update()
                 .GetLatestRecord()
                 .FieldValueEquals("Latest Version", true)
                 .LookupFieldValueEquals(substatus, "Sub Status", "Internally Approved")
                 .FieldValueEquals("ownerid", contractAdviserName); ;

            contractRecord
                .GetLatestRelatedRecord(workflowHistory)
                .LookupFieldValueEquals(transition, "Action", "Approve for Issue")
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Completed On", DateTime.Today)
                .LookupFieldValueEquals(systemUser, "Completed By", contractManagerName)
                .FieldValueEquals("Previous Task Owner", contractManagerName)
                .FieldValueEquals("New Task Owner", contractAdviserName)
                .FieldValueEquals("Previous Status", "Draft")
                .FieldValueEquals("New Status", "Draft")
                .LookupFieldValueEquals(substatus, "Previous Sub Status", "Awaiting Internal Approval")
                .LookupFieldValueEquals(substatus, "New Sub Status", "Internally Approved");

            var providerLink = TestBase.CrmConfiguration.Entity("Organisation");

            string desc = contractRecord.GetField("UKPRN").ToString() + " - " +
                          contractRecord.GetLookupFieldName(providerLink, "Provider");

            contractRecord
                .GetLatestRelatedRecord(task, "Regarding")
                .FieldValueEquals("Subject", "Confirm Publication to Provider")
                .FieldValue(XrmFieldValueComparison.BeginsWith, "Description", desc)
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Due By", DateTime.Today.AddDays(5))
                .FieldValueEquals("Status", "Not Started")
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Created On", DateTime.Today)
                .FieldValueEquals("ownerid", contractAdviserName);

            var tasks = contractRecord.GetRelatedRecords(task);

            foreach (var t in tasks.Skip(1))
            {
                t.FieldValueEquals("Status", "Completed");
            }
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "80")]

        public void TestContractManagerApproveProcessViaTasks()
        {
            var contract = TestBase.CrmConfiguration.Entity("Contract");
            var substatus = TestBase.CrmConfiguration.Entity("Status");
            var systemUser = TestBase.CrmConfiguration.Entity("User");
            var workflowHistory = TestBase.CrmConfiguration.Entity("Workflow History");
            var task = TestBase.CrmConfiguration.Entity("Task");
            var activity = TestBase.CrmConfiguration.Entity("Activity");
            
            var transition = TestBase.CrmConfiguration.Entity("Transition");
            var transitionRecordApprove = TestBase.Connection
                .GetRecord(transition, "Approve For Issue");

            var contractRecord = TestBase.ConnectAsUser(contractManagerName)
                 .GetRecord(contract, contractNumber)
                 .LookupFieldValueEquals(substatus, "Sub Status", "Awaiting Internal Approval");

            var providerLink = TestBase.CrmConfiguration.Entity("Organisation");

            contractRecord
                .GetLatestRelatedRecord(task, "Regarding")
                .SetField("Status", "Completed")
                .SetField("State", "Completed")
                .UpdateStatus();

            contractRecord
                .GetLatestRecord()
                 .LookupFieldValueEquals(substatus, "Sub Status", "Internally Approved");

            var taskRecords = contractRecord.GetRelatedRecords(task, "Regarding");
            
            foreach (var t in taskRecords.Skip(1))
            {
                t.FieldValueEquals("Status", "Completed");
            }

            
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "80")]
        public void CheckContractManagerHasReadOnlyAccessOnContract()
        {
            TestBase.CrmConfiguration.Entity("Contract");

            var contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            TestBase.Connection.Role("Contract Manager")
                .HasPrivilege(contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                .HasPrivilege(contractLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege(contractLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege(contractLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }
    }
}