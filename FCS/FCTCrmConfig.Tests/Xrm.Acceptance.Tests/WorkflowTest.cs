using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Ciber.Xrm.Tests;

namespace FCTCrmConfig.AcceptanceTests
{
    [TestClass]
    public class WorkflowTest
    {
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "999")]
        public void CheckWorkflowTest()
        {
            //var contract = TestBase.CrmConfiguration.Entity("Contract");
            //var workflowHistory = TestBase.CrmConfiguration.Entity("Workflow History");

            //var contractRecord = TestBase.Connection
            //    .GetRecord(contract, "CON-12345678")
            //    .FieldValueEquals("Description", "A")
            //    .UpdateField("Description", "B")
            //    .GetLatestRecord()
            //    .FieldValueEquals("Description", "B")
            //    .UpdateField("Description", "A");

            // contractRecord
            //    .GetLatestRelatedRecord(workflowHistory)
            //     .FieldValueEquals("Previous Status", "Draft"); 

        }

        [TestMethod]
        [TestProperty("StoryNo", "999")]
        public void CheckWorkflowTest2()
        {
            //var contract = TestBase.CrmConfiguration.Entity("Contract");
            //var fundingType = TestBase.CrmConfiguration.Entity("Funding Type");

            //TestBase.ConnectAsRole("Contract Adviser")
            //    .GetRecord(contract, "SFA-000029")
            //    .FieldValue(XrmFieldValueComparison.NotEquals,"Latest Version", true)
            //    //.FieldValueEquals("Description", "A")
            //    .FieldValue(XrmFieldValueComparison.Equals,"Contract Value", 2000000.00)
            //    .FieldValue(XrmFieldValueComparison.LessThan,"Start Date", new DateTime(2015, 08, 1))
            //    .FieldValue(XrmFieldValueComparison.GreaterThan,"Contract Status", "Draft")
            //    .LookupFieldValueEquals(fundingType, "Funding Type","Financial Memorandum")
            //    ;

            //var k = TestBase.ConnectAsUser("Sarah")
            //    .GetRecord(contract, "CON-12345678")
            //    .FieldValueEquals("Latest Version", true)
            //    .UpdateField("Latest Version", false)
            //    .GetLatestRecord()
            //    .FieldValueEquals("Latest Version", false)
            //    .UpdateField("Latest Version", true)
            //    .GetLatestRecord()
            //    .FieldValueEquals("Latest Version", true)
            //    ;

        }

        [TestMethod]
        [TestProperty("StoryNo", "999")]
        public void CheckWorkflowTest3()
        {
            //var contract = TestBase.CrmConfiguration.Entity("Contract");
            //var transition = TestBase.CrmConfiguration.Entity("Transition");

            //var transitionRecordImportedId = TestBase.Connection
            //    .GetRecord(transition, "Record Imported");

            //TestBase.Connection
            //    .SetRecord(contract, "CON-9999999")
            //    .SetField("Latest Version", true)
            //    .SetField("Description", "A")
            //    .SetField("Contract Value", 6557)
            //    .SetField("Start Date",   DateTime.Today)
            //    .SetField("Contract Status", "Draft")
            //    .SetLookupField(transition, "Next Action", transitionRecordImportedId)
            //    .Create()
            //    .GetLatestRecord()
            //    .FieldValueEquals("Start Date", DateTime.Today)
            //    ;

            //TestBase.ConnectAsUser("Sarah")
            //     .GetRecord(contract, "CON-9999999")
            //     .FieldValueEquals("Latest Version", true)
            //     .UpdateField("Latest Version", false)
            //     .GetLatestRecord()
            //     .FieldValueEquals("Latest Version", false)
            //     .UpdateField("Latest Version", true)
            //     .GetLatestRecord()
            //     .FieldValueEquals("Latest Version", true)
            //     ;

        }
    }
}