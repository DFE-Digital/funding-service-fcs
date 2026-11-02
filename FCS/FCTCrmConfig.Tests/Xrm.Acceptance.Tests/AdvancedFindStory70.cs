using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class AdvancedFindStory70 : TestBase
    {

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo","70")]
        public void CheckContractEntityExists()
        {
            TestBase.CrmConfiguration.Entity("Contract");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasDisplayNameContract()
        {
            TestBase.CrmConfiguration.Entity("Contract").HasDisplayName("Contract");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasContractNumber()
        {
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Contract No")
                                                        .IsValidForAdvancedFind();
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasContractVersion()
        {
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Version")
                                                        .IsValidForAdvancedFind();
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasUKPRN()
        {
            TestBase.CrmConfiguration.Entity("Contract")
                .Attribute("UKPRN")
                .IsValidForAdvancedFind();
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasProviderName()
        {
            TestBase.CrmConfiguration.Entity("Organisation")
                .Relationship(TestBase.CrmConfiguration.Entity("Contract").LogicalName)
                .HasDisplayName("Provider");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasFundingType()
        {
            TestBase.CrmConfiguration.Entity("Funding Type")
                .Relationship(TestBase.CrmConfiguration.Entity("Contract").LogicalName)
                .HasDisplayName("Funding Type");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasContractStatus()
        {
            TestBase.CrmConfiguration.Entity("Contract")
                .Attribute("Contract Status")
                .IsValidForAdvancedFind();

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasSubStatus()
        {
            TestBase.CrmConfiguration.Entity("Status")
                .Relationship(TestBase.CrmConfiguration.Entity("Contract").LogicalName)
                .HasDisplayName("Sub Status");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasContractOwner()
        {
            var contract = TestBase.CrmConfiguration.Entity("Contract");

            TestBase.CrmConfiguration.Entity("User")
                .Relationship(contract.LogicalName, "Contract Owner")
                .HasDisplayName("Contract Owner")
                .IsAvailableForAdvanceFind(true);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasStartDate()
        {
            TestBase.CrmConfiguration.Entity("Contract")
                .Attribute("Start Date")
                .IsValidForAdvancedFind()
                .HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasEndDate()
        {

            TestBase.CrmConfiguration.Entity("Contract").Attribute("End Date")
                                                        .IsValidForAdvancedFind()
                                                        .HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityHasContractValue()
        {

            TestBase.CrmConfiguration.Entity("Contract").Attribute("Contract Value")
                                                        .IsValidForAdvancedFind();

        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityDefaultView()
        {
            TestBase.CrmConfiguration.Entity("Contract").DefaultView().ViewNameEquals("Latest Contracts");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityDefaultViewHasCorrectFilters()
        {
            TestBase.CrmConfiguration.Entity("Contract").View("Latest Contracts")
               .HasFilter("State", XrmFilterOperator.EqualTo, "Active")
               .HasFilter("Latest Version", XrmFilterOperator.EqualTo, "Yes");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckContractEntityDefaultViewHasCorrectColumns()
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

            TestBase.CrmConfiguration.Entity("Contract").DefaultView()
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
                    .HasColumn(contractOwner);
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckAdvancedFindHasCorrectSearchFields()
        {
            string contractLogicalName = TestBase.CrmConfiguration.Entity("Contract").LogicalName;

            TestBase.CrmConfiguration.Entity("Organisation").Relationship(contractLogicalName)
                    .HasDisplayName("Provider")
                    .IsAvailableForAdvanceFind(true);

            TestBase.CrmConfiguration.Entity("Contract").Attribute("UKPRN").IsValidForAdvancedFind();
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Contract No").IsValidForAdvancedFind();
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Version").IsValidForAdvancedFind();

            TestBase.CrmConfiguration.Entity("Contract")
                    .Relationship(contractLogicalName, "Previous Version")
                    .HasDisplayName("Previous Version")
                    .IsAvailableForAdvanceFind(true);

            TestBase.CrmConfiguration.Entity("Funding Type").Relationship(contractLogicalName)
                    .HasDisplayName("Funding Type")
                    .IsAvailableForAdvanceFind(true);

            TestBase.CrmConfiguration.Entity("Contract").Attribute("Latest Version").IsValidForAdvancedFind();
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Contract Value").IsValidForAdvancedFind();
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Description").IsValidForAdvancedFind();
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Start Date").IsValidForAdvancedFind();
            TestBase.CrmConfiguration.Entity("Contract").Attribute("End Date").IsValidForAdvancedFind();
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Contract Status").IsValidForAdvancedFind();
            TestBase.CrmConfiguration.Entity("Status").Relationship(contractLogicalName)
                    .HasDisplayName("Sub Status")
                    .IsAvailableForAdvanceFind(true);
            TestBase.CrmConfiguration.Entity("Contract").Attribute("Last Approved Version").IsValidForAdvancedFind();
       
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "70")]
        public void CheckSearchResultIsDecsendingContractNumber()
        {
            TestBase.CrmConfiguration.Entity("Contract").View("Latest Contracts").HasSortColumn("Contract No", XrmSortOrder.Descending);

        }
    }

}  




    