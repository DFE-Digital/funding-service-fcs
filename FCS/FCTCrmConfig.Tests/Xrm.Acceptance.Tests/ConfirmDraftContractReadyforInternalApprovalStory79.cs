using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class ConfirmDraftContractReadyforInternalApprovalStory79
    {
        private DateTime testStartDateTime = DateTime.Now;
        private string contractNumber = "TST-8033100";
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
                .Create()
                .GetLatestRecord()
                .FieldValueEquals("Start Date", testStartDateTime)
                ;
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "79")]
        public void TestRequestInternalApprovalProcess()
        {
            var contract = TestBase.CrmConfiguration.Entity("Contract");
            var subStatus = TestBase.CrmConfiguration.Entity("Status");
            var systemUser = TestBase.CrmConfiguration.Entity("User");
            var workflowHistory = TestBase.CrmConfiguration.Entity("Workflow History");
            var transition = TestBase.CrmConfiguration.Entity("Transition");
            var systemuser = TestBase.CrmConfiguration.Entity("User");
            var substatus = TestBase.CrmConfiguration.Entity("Status");
            var task = TestBase.CrmConfiguration.Entity("Task");

            var transitionRecord = TestBase.Connection.GetRecord(transition, "Release for Internal Approval");

            var contractAdviser = TestBase.Connection.GetRecord(systemUser, contractAdviserName, "FullName");

            var contractRecord = TestBase.ConnectAsUser(contractAdviserName)
                .GetRecord(contract, contractNumber)
                .LookupFieldValueEquals(subStatus, "Sub Status", "In Review")
                .SetLookupField(systemUser, "Modified By", contractAdviser)
                .SetLookupField(transition, "Next Action", transitionRecord)
                .Update()
                .GetLatestRecord()
                .FieldValueEquals("Latest Version", true)
                .LookupFieldValueEquals(subStatus, "Sub Status", "Awaiting Internal Approval")
                .FieldValueEquals("ownerid", contractManagerName);

            contractRecord
                .GetLatestRelatedRecord(workflowHistory)
                .LookupFieldValueEquals(transition, "Action", "Release For Internal Approval")
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Completed On", DateTime.Today)
                .LookupFieldValueEquals(systemuser, "Completed By", contractAdviserName)
                .FieldValueEquals("Previous Task Owner", contractAdviserName)
                .FieldValueEquals("New Task Owner", contractManagerName)
                .FieldValueEquals("Previous Status", "Draft")
                .FieldValueEquals("New Status", "Draft")
                .LookupFieldValueEquals(substatus, "Previous Sub Status", "In Review")
                .LookupFieldValueEquals(substatus, "New Sub Status", "Awaiting Internal Approval");

            var providerLink = TestBase.CrmConfiguration.Entity("Organisation");
            string desc = contractRecord.GetField("UKPRN").ToString() + " - " +
                          contractRecord.GetLookupFieldName(providerLink, "Provider").ToString();

            contractRecord
                .GetLatestRelatedRecord(task, "Regarding")
                .FieldValueEquals("Subject", "Confirm Internal Approval")
                .FieldValue(XrmFieldValueComparison.BeginsWith, "Description", desc)
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Due By", DateTime.Today.AddDays(5))
                .FieldValueEquals("Status", "Not Started")
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Created On", DateTime.Today)
                .FieldValueEquals("ownerid", contractManagerName);

            var tasks = contractRecord
               .GetRelatedRecords(task, "Regarding");

            foreach (var t in tasks.Skip(1))
            {
                t.FieldValueEquals("Status", "Completed");
            }

        }

        //Confirm Required entities are available
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "78")]
        public void CheckContractAdviserHasReadOnlyAccessOnContract()
        {
            TestBase.CrmConfiguration.Entity("Contract");

            var contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            TestBase.Connection.Role("Contract Adviser")
                .HasPrivilege(contractLogicalName, XrmSecurityAction.Read, XrmSecurityPriv.Organization)
                .HasPrivilege(contractLogicalName, XrmSecurityAction.Create, XrmSecurityPriv.None)
                .HasPrivilege(contractLogicalName, XrmSecurityAction.Delete, XrmSecurityPriv.None)
                .HasPrivilege(contractLogicalName, XrmSecurityAction.Write, XrmSecurityPriv.User);

        }
    }
} 
