using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class ViewLatestContractStory275 : TestBase
    {
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "275")]
        public void CheckContractEntityExists()
        {
            TestBase.CrmConfiguration.Entity("Contract");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "275")]
        public void CheckContractEntityDefaultView()
        {
            TestBase.CrmConfiguration.Entity("Contract").DefaultView().ViewNameEquals("Latest Contracts");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "275")]
        public void CheckContractEntityLatestViewHasCorrectColumns()
        {
            TestBase.CrmConfiguration.Entity("Contract").View("Latest Contracts");

            string contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            string providerLink = TestBase.CrmConfiguration.Entity("Organisation")
                     .Relationship(contractLogicalName)
                     .HasDisplayName("Provider")
                     .LogicalName;

            string fundingTypeLink = TestBase.CrmConfiguration.Entity("Funding Type")
                    .Relationship(contractLogicalName)
                    .HasDisplayName("Funding Type")
                    .LogicalName;
            string statusLink = TestBase.CrmConfiguration.Entity("Status")
                 .Relationship(contractLogicalName)
                 .HasDisplayName("Sub Status")
                 .LogicalName;
            string contractOwnerLink = TestBase.CrmConfiguration.Entity("User")
                .Relationship(contractLogicalName, "Contract Owner")
                .HasDisplayName("Contract Owner")
                .LogicalName;

            TestBase.CrmConfiguration.Entity("Contract").View("Latest Contracts")
                     .HasColumn("Contract No")
                     .HasColumn("Version")
                     .HasColumn("UKPRN")
                     .HasColumn("Contract Status")
                     .HasColumn(providerLink)
                     .HasColumn(fundingTypeLink)
                     .HasColumn(statusLink)
                     .HasColumn("Contract Value")
                     .HasColumn("Start Date")
                     .HasColumn("End Date")
                     .HasColumn(contractOwnerLink);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "275")]
        public void CheckLatestViewIsDecsendingContractNumber()
        {
            TestBase.CrmConfiguration.Entity("Contract").View("Latest Contracts").HasSortColumn("Contract No", XrmSortOrder.Descending);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "275")]
        public void CheckLatestContractViewtColumnsIsSortEnabled()
        {
            TestBase.CrmConfiguration.Entity("Contract").View("Latest Contracts")
               .HasFilter("State", XrmFilterOperator.EqualTo, "Active")
               .HasFilter("Latest Version", XrmFilterOperator.EqualTo, "Yes");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "275")]
        public void CheckAllContractViewHasCorrectColumns()
        {
            string contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            string providerLink = TestBase.CrmConfiguration.Entity("Organisation")
                     .Relationship(contractLogicalName)
                     .HasDisplayName("Provider")
                     .LogicalName;

            string fundingTypeLink = TestBase.CrmConfiguration.Entity("Funding Type")
                    .Relationship(contractLogicalName)
                    .HasDisplayName("Funding Type")
                    .LogicalName;
            string statusLink = TestBase.CrmConfiguration.Entity("Status")
                 .Relationship(contractLogicalName)
                 .HasDisplayName("Sub Status")
                 .LogicalName;

            string contractOwner = TestBase.CrmConfiguration.Entity("User")
                .Relationship(contractLogicalName, "Contract Owner")
                .HasDisplayName("Contract Owner")
                .LogicalName;

            TestBase.CrmConfiguration.Entity("Contract").View("All Contracts")
                    .HasColumn("Contract No")
                    .HasColumn("Version")
                    .HasColumn("UKPRN")
                    .HasColumn("Contract Status")
                     .HasColumn(providerLink)
                     .HasColumn(fundingTypeLink)
                     .HasColumn(statusLink)
                    .HasColumn("Contract Value")
                    .HasColumn("Start Date")
                    .HasColumn("End Date")
                    .HasColumn(contractOwner);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "275")]
        public void CheckAllContractsViewIsDecsendingContractNumber()
        {
            TestBase.CrmConfiguration.Entity("Contract").View("All Contracts").HasSortColumn("Contract No", XrmSortOrder.Descending);
        }
    }
}