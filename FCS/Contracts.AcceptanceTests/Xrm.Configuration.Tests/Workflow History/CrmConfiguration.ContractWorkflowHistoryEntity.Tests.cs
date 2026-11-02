namespace SFA.FCT.Xrm.Configuration.Tests.Workflow_History
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    [TestClass]
    public class XrmConfigurationContractWorkflowHistoryEntity : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void ContractHistoryExists()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .HasDisplayName("Workflow History");
        }

        #endregion

        #region Views

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityAssociatedViewContainsCorrectColumns()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .View("Workflow History")
                .HasColumn("sfa_action")
                .HasColumn("sfa_actionon")
                .HasColumn("sfa_actionby")
                .HasColumn("sfa_previousstatus")
                .HasColumn("sfa_newstatus")
                .HasColumn("sfa_previoussubstatus")
                .HasColumn("sfa_newsubstatus")
                .HasColumn("sfa_newowner")
                .HasColumn("sfa_previousowner")
                .HasSortColumn("sfa_actionon", XrmSortOrder.Descending);

            #endregion
        }

        #region Attributes

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityContainsAction()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .Attribute("sfa_name").HasType(XrmDataType.Text);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityContainsComments()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .Attribute("sfa_comments").HasType(XrmDataType.Memo);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityContainsPreviousTaskOwner()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .Attribute("sfa_previousowner")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityContainsNewTaskOwner()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .Attribute("sfa_newowner")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityContainsPreviousStatus()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .Attribute("sfa_previousstatus").HasType(XrmDataType.OptionSet);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityContainsNewStatus()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .Attribute("sfa_newstatus").HasType(XrmDataType.OptionSet);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityContainsTransition()
        {
            CrmConfiguration.Entity("sfa_contract")
                .Relationship("sfa_contracttransitionhistory");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        public void WorkflowHistoryEntityContainsActionCompletedOn()
        {
            CrmConfiguration.Entity("sfa_contracttransitionhistory")
                .Attribute("sfa_actionon").HasType(XrmDataType.DateTime);
        }

        #endregion

        #region Forms

        #endregion
    }
}