using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class ViewWorkflowHistoryStory84
    {
        
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "84")]
        public void CheckContractFormIsAvailable()
        {
            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main);
        }
        
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "84")]
        public void ContractFormHasWorkflowHistorySubGrid()
        {
            var view = TestBase.CrmConfiguration.Entity("Workflow History").View("Workflow History");

            TestBase.CrmConfiguration.Entity("Contract").Form("Information", XrmFormType.Main)
                    .HasTab("Workflow History")
                    .HasSubGridWithView(view.ViewId.ToUpperInvariant());
        }
        
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "84")]

        public void CheckWorkflowHistoryHasCorrectColumns()
        {
            string workflowHistoryLogicalName = TestBase.CrmConfiguration.Entity("Workflow History").LogicalName;

            string actionLink = TestBase.CrmConfiguration.Entity("Transition")
                    .Relationship(workflowHistoryLogicalName)
                    .HasDisplayName("Action")
                    .LogicalName;

            string completedByLink = TestBase.CrmConfiguration.Entity("User")
                    .Relationship(workflowHistoryLogicalName,"Completed By")
                    .HasDisplayName("Completed By")
                    .LogicalName;

            string previousSubStatusLink = TestBase.CrmConfiguration.Entity("Status")
                    .Relationship(workflowHistoryLogicalName, "Previous Sub Status")
                    .HasDisplayName("Previous Sub Status")
                    .LogicalName;

            string newSubStatusLink = TestBase.CrmConfiguration.Entity("Status")
                    .Relationship(workflowHistoryLogicalName, "New Sub Status")
                    .HasDisplayName("New Sub Status")
                    .LogicalName;

            TestBase.CrmConfiguration.Entity("Workflow History").View("Workflow History")
                .HasColumn("Completed On") //This is a date and time field
                .HasColumn(actionLink)
                .HasColumn(completedByLink)
                .HasColumn("Previous Task Owner")
                .HasColumn("New Task Owner")
                .HasColumn("Previous Status")
                .HasColumn("New Status")
                .HasColumn(previousSubStatusLink)
                .HasColumn(newSubStatusLink);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "84")]
        public void CheckWorkflowHistoryIsDescendingCreatedOn()
        {
            TestBase.CrmConfiguration.Entity("Workflow History").View("Workflow History").HasSortColumn("Completed On", XrmSortOrder.Descending);

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "84")]
        public void CheckFieldType()
        {
            TestBase.CrmConfiguration.Entity("Workflow History")
                        .Attribute("Completed On")
                          .HasType(XrmDataType.DateTime);
        }
    }
}
