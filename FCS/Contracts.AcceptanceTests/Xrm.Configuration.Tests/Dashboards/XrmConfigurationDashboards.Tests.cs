namespace SFA.FCT.Xrm.Configuration.Tests.Dashboards
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class XrmConfigurationDashboards : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void ManagersDashboardsExists()
        {
            CrmConfiguration.Dashboard("Contract Manager Dashboard");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void ManagersDashboardIsNotSystemDefault()
        {
            CrmConfiguration.Dashboard("Contract Manager Dashboard").IsSystemDefault(false);
        }

        //[TestMethod]
        //[TestCategory("CRMConfiguration")]
        //[TestProperty("StoryNo", "636")]
        //public void ManagersDashboardHasMyTasksView()
        //{
        //    var myTasksView = CrmConfiguration.Entity("Task").View("My Tasks").ViewId;

        //    CrmConfiguration.Dashboard("Contract Manager Dashboard").HasGridWithView(myTasksView.ToUpperInvariant(), true);
        //}

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void ManagersDashboardHasContractManagerTaskView()
        {
            var myTasksView = CrmConfiguration.Entity("Task").View("Contract Manager Task").ViewId;

            CrmConfiguration.Dashboard("Contract Manager Dashboard").HasGridWithView(myTasksView.ToUpperInvariant(), true);
        }




        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void ManagersDashboardHasMyContractCaseloadContractOwnerView()
        {
            var latestContractsView = CrmConfiguration.Entity("Contract").View("My Contract Caseload (Contract Owner)").ViewId;

            CrmConfiguration.Dashboard("Contract Manager Dashboard").HasGridWithView(latestContractsView.ToUpperInvariant(), true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void ManagersDashboardHasMyContractCaseloadTaskOwnerView()
        {
            var latestContractsView = CrmConfiguration.Entity("Contract").View("My Contract Caseload (Task Owner)").ViewId;

            CrmConfiguration.Dashboard("Contract Manager Dashboard").HasGridWithView(latestContractsView.ToUpperInvariant(), true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void ManagersDashboardHasManagerNotificationsView()
        {
            var myNotificationsView = CrmConfiguration.Entity("Notification").View("Manager Notifications").ViewId;

            CrmConfiguration.Dashboard("Contract Manager Dashboard").HasGridWithView(myNotificationsView.ToUpperInvariant(), false);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void AdvisersDashboardsExists()
        {
            CrmConfiguration.Dashboard("Contract Adviser Dashboard");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void AdvisersDashboardIsNotSystemDefault()
        {
            CrmConfiguration.Dashboard("Contract Adviser Dashboard").IsSystemDefault(true);
        }

        //[TestMethod]
        //[TestCategory("CRMConfiguration")]
        //[TestProperty("StoryNo", "636")]
        //public void AdvisersDashboardHasMyTasksView()
        //{
        //    var myTasksView = CrmConfiguration.Entity("Task").View("My Tasks").ViewId;

        //    CrmConfiguration.Dashboard("Contract Adviser Dashboard").HasGridWithView(myTasksView.ToUpperInvariant(), true);
        //}

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void AdvisersDashboardHasContractAdviserTask()
        {
            var myTasksView = CrmConfiguration.Entity("Task").View("Contract Adviser Team Tasks").ViewId;

            CrmConfiguration.Dashboard("Contract Adviser Dashboard").HasGridWithView(myTasksView.ToUpperInvariant(), true);
        }



        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void AdvisersDashboardHasLatestContractsView()
        {
            var latestContractsView = CrmConfiguration.Entity("sfa_contract").View("My Latest Contracts").ViewId;

            CrmConfiguration.Dashboard("Contract Adviser Dashboard").HasGridWithView(latestContractsView.ToUpperInvariant(), true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "636")]
        public void AdvisersDashboardHasMyNotificationsView()
        {
            var myNotificationsView = CrmConfiguration.Entity("Notification").View("My Notifications").ViewId;

            CrmConfiguration.Dashboard("Contract Adviser Dashboard").HasGridWithView(myNotificationsView.ToUpperInvariant(), false);
        }
    }
}