using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{

    [TestClass]
    public class QuickSearchStory71 : TestBase
    {
        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "71")]
        public void CheckContractEntityExists()
        {
            TestBase.CrmConfiguration.Entity("Contract");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "71")]
        public void CheckContractEntityDefaultView()
        {
            TestBase.CrmConfiguration.Entity("Contract").DefaultView().ViewNameEquals("Latest Contracts");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "71")]
        public void CheckQuickSearchHasCorrectSearchFields()
        {
            string contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            string providerLink = TestBase.CrmConfiguration.Entity("Organisation")
                    .Relationship(contractLogicalName)
                    .HasDisplayName("Provider")
                    .LogicalName;

            TestBase.CrmConfiguration.Entity("Contract").QuickView()
            .HasSearchField(providerLink)
            .HasSearchField("UKPRN")
            .HasSearchField("Contract No");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "71")]
        public void CheckLatestVersionIsDispalyed()
        {
            TestBase.CrmConfiguration.Entity("Contract").QuickView()
                       .Equals("Latest Version");

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "71")]
        public void CheckContractEntityQuickSearchViewHasCorrectColumns()
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

            string contractOwnerLink = TestBase.CrmConfiguration.Entity("User")
                   .Relationship(contractLogicalName, "Contract Owner")
                   .HasDisplayName("Contract Owner")
                   .LogicalName;

            TestBase.CrmConfiguration.Entity("Contract").QuickView()
                    .HasColumn("Contract No")
                    .HasColumn("Version")
                    .HasColumn("UKPRN")
                    .HasColumn(providerLink)
                    .HasColumn(fundingTypeLink)
                    .HasColumn("Contract Status")
                    .HasColumn(statusLink)
                    .HasColumn("Contract Value")
                    .HasColumn("Start Date")
                    .HasColumn("End Date")
                    .HasColumn(contractOwnerLink);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "71")]

        public void CheckQuickSearchResultIsDecsendingContractNumber()
        {
            TestBase.CrmConfiguration.Entity("Contract").QuickView().HasSortColumn("Contract No", XrmSortOrder.Descending);
        }





    }
}
