using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class RejectDraftContractAtApprovalStory82
    {
        private DateTime testStartDateTime = DateTime.Now;
        private string contractNumber = "TST-8033300";
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
        [TestProperty("StoryNo", "82")]
        public void TestContractManagerRejectProcess()
        {
            var contract = TestBase.CrmConfiguration.Entity("Contract");
            var substatus = TestBase.CrmConfiguration.Entity("Status");
            var systemUser = TestBase.CrmConfiguration.Entity("User");
            var workflowHistory = TestBase.CrmConfiguration.Entity("Workflow History");
            var task = TestBase.CrmConfiguration.Entity("Task");

            var transition = TestBase.CrmConfiguration.Entity("Transition");
            var transitionRecordReject = TestBase.Connection
                .GetRecord(transition, "Reject");

            var contractRecord = TestBase.ConnectAsUser(contractManagerName)
                 .GetRecord(contract, contractNumber)
                 .LookupFieldValueEquals(substatus, "Sub Status", "Awaiting Internal Approval")
                 .SetLookupField(transition, "Next Action", transitionRecordReject)
                 .Update()
                 .GetLatestRecord()
                 .FieldValueEquals("Latest Version", true)
                 .LookupFieldValueEquals(substatus, "Sub Status", "In Review")
                 .FieldValueEquals("ownerid", contractAdviserName);

            contractRecord
                .GetLatestRelatedRecord(workflowHistory)
                .LookupFieldValueEquals(transition, "Action", "Reject")
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Completed On", DateTime.Today)
                .LookupFieldValueEquals(systemUser, "Completed By", contractManagerName)
                .FieldValueEquals("Previous Task Owner", contractManagerName)
                .FieldValueEquals("New Task Owner", contractAdviserName)
                .FieldValueEquals("Previous Status", "Draft")
                .FieldValueEquals("New Status", "Draft")
                .LookupFieldValueEquals(substatus, "Previous Sub Status", "Awaiting Internal Approval")
                .LookupFieldValueEquals(substatus, "New Sub Status", "In Review");

            var providerLink = TestBase.CrmConfiguration.Entity("Organisation");
            string desc = contractRecord.GetField("UKPRN").ToString() + " - " +
                          contractRecord.GetLookupFieldName(providerLink, "Provider");

            contractRecord
                .GetLatestRelatedRecord(task, "Regarding")
                .FieldValueEquals("Subject", "Progress Rejected Contract")
                .FieldValue(XrmFieldValueComparison.BeginsWith, "Description", desc)
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Due By", DateTime.Today.AddDays(5))
                .FieldValueEquals("Status", "Not Started")
                .FieldValue(XrmFieldValueComparison.GreaterThan, "Created On", DateTime.Today)
                .FieldValueEquals("ownerid",contractAdviserName);

            var tasks = contractRecord.GetRelatedRecords(task);

            foreach (var t in tasks.Skip(1))
            {
                t.FieldValueEquals("Status", "Completed");
            }
        }
    }
}

