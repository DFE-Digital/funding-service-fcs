namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Linq;
    using System.Reflection;
    using System.ServiceModel.Syndication;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ApprovalOnwardsAtomFeedSyndicationItemCreatorTests
    {
        private const string MediaType = "application/json";

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsAtomFeedSyndicationItemCreator_ShouldCreateSyndicationItemWithCorrectData_ForClosedContract()
        {
            // arrange
            AllContractAtomFeedSyndicationItemCreator creator =
                new AllContractAtomFeedSyndicationItemCreator(MediaType);
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();
            string key = "ABC-123:1:0";

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, key, AtomItemType.ClosedContract, xml => true);

            // act
            SyndicationItem closedContractItem = creator.CreateItemForRow(item, MediaType);

            // assert
            Assert.AreEqual($"Contract {key} was Closed", closedContractItem.Title.Text, "Title is incorrect");
            Assert.AreEqual("Contract Closed", closedContractItem.Categories.First().Name, "Category term is incorrect");
            Assert.AreEqual("A contract has been closed", closedContractItem.Categories.First().Label, "Category label is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsAtomFeedSyndicationItemCreator_ShouldCreateSyndicationItemWithCorrectData_ForApprovedContract()
        {
            // arrange
            AllContractAtomFeedSyndicationItemCreator creator =
                new AllContractAtomFeedSyndicationItemCreator(MediaType);
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();
            string key = "ABC-123:1:0";

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, key, AtomItemType.ApprovedContract, xml => true);

            // act
            SyndicationItem closedContractItem = creator.CreateItemForRow(item, MediaType);

            // assert
            Assert.AreEqual($"Contract {key} was Approved", closedContractItem.Title.Text, "Title is incorrect");
            Assert.AreEqual("Approved Contract", closedContractItem.Categories.First().Name, "Category term is incorrect");
            Assert.AreEqual("A contract has been approved", closedContractItem.Categories.First().Label, "Category label is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsAtomFeedSyndicationItemCreator_ShouldCreateSyndicationItemWithCorrectData_ForCancelledContractTermination()
        {
            // arrange
            AllContractAtomFeedSyndicationItemCreator creator = new AllContractAtomFeedSyndicationItemCreator(MediaType);
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();
            const string key = "ABC-123:1:0";

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, key, AtomItemType.CancelledContractTermination, xml => true);

            // act
            SyndicationItem cancelledContractTerminationItem = creator.CreateItemForRow(item, MediaType);

            // assert
            Assert.AreEqual($"Termination of contract {key} was cancelled", cancelledContractTerminationItem.Title.Text, "Title is incorrect");
            Assert.AreEqual("Contract Termination Cancelled", cancelledContractTerminationItem.Categories.First().Name, "Category term is incorrect");
            Assert.AreEqual("Termination of a contract has been cancelled", cancelledContractTerminationItem.Categories.First().Label, "Category label is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApprovalOnwardsAtomFeedSyndicationItemCreator_ShouldCreateSyndicationItemWithCorrectData_ForContractTerminationDetailsUpdated()
        {
            // arrange
            AllContractAtomFeedSyndicationItemCreator creator = new AllContractAtomFeedSyndicationItemCreator(MediaType);
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();
            const string key = "ABC-123:1:0";

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, key, AtomItemType.ContractTerminationDetailsUpdated, xml => true);

            // act
            SyndicationItem contractTerminationDetailsUpdatedItem = creator.CreateItemForRow(item, MediaType);

            // assert
            Assert.AreEqual($"Termination details for contract {key} have been updated", contractTerminationDetailsUpdatedItem.Title.Text, "Title is incorrect");
            Assert.AreEqual("Contract Termination Details Updated", contractTerminationDetailsUpdatedItem.Categories.First().Name, "Category term is incorrect");
            Assert.AreEqual("Termination details for a contract have been updated", contractTerminationDetailsUpdatedItem.Categories.First().Label, "Category label is incorrect");
        }

        private static CrossDomain.Integration.Entities.CorporateContract.Contract GetCorpContract()
        {
            using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("ContractManagementService.Tests.Resources.masterContract.xml");
            var document = XDocument.Load(stream);

            XmlSerializer serializer =
                new XmlSerializer(typeof(CrossDomain.Integration.Entities.CorporateContract.Contract));
            return (CrossDomain.Integration.Entities.CorporateContract.Contract)
                serializer.Deserialize(document.Root.CreateReader());
        }
    }
}