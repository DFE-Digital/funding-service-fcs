namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AllContractAtomFeedSyndicationItemCreatorTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGetSummaryTextForCountractInCorrectFormatForDraft()
        {
            // arrange
            var creator =
                new DraftContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.DraftContract, xml => true);

            // act
            string summaryText = creator.GetSummaryText(item);

            // assert
            Assert.AreEqual(contract.ToString(), summaryText);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGetSummaryTextForCountractInCorrectFormatForWithdraw()
        {
            // arrange
            var creator =
                new WithdrawnContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.WithdrawnContract, xml => true);

            // act
            string summaryText = creator.GetSummaryText(item);

            // assert
            Assert.AreEqual(contract.ToString(), summaryText);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGetSummaryTextForCountractInCorrectFormatForApproved()
        {
            // arrange
            var creator =
                new ApprovedContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.ApprovedContract, xml => true);

            // act
            string summaryText = creator.GetSummaryText(item);

            // assert
            Assert.AreEqual(contract.ToString(), summaryText);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateItemForRow_ShouldCreateSyndicationItemWithExpectedValuesDraft()
        {
            // arrange
            var creator =
                new DraftContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.DraftContract, xml => true);
          
            //act
            var result = creator.CreateItemForRow(item, "Application/json");

            // assert
            Assert.AreEqual(contract.ToString(), result.Summary.Text, "Summary not same");
            Assert.AreEqual($"uuid:{item.Identifier}", result.Id,"Id not same");
            Assert.AreEqual($"Contract {item.BusinessKey} was Published to Provider", result.Title.Text, "Title not same");
            Assert.AreEqual("A contract has been Published to Provider", result.Categories[0].Label, "Label not same");
            Assert.AreEqual("Contract Published to Provider", result.Categories[0].Name, "Name not same");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateItemForRow_ShouldCreateSyndicationItemWithExpectedValuesWithdrawn()
        {
            // arrange
            var creator =
                new DraftContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.WithdrawnContract, xml => true);

            //act
            var result = creator.CreateItemForRow(item, "Application/json");

            // assert
            Assert.AreEqual(contract.ToString(), result.Summary.Text, "Summary not same");
            Assert.AreEqual($"uuid:{item.Identifier}", result.Id, "Id not same");
            Assert.AreEqual($"Contract {item.BusinessKey} was Published to Provider", result.Title.Text, "Title not same");
            Assert.AreEqual("A contract has been Published to Provider", result.Categories[0].Label, "Label not same");
            Assert.AreEqual("Contract Published to Provider", result.Categories[0].Name, "Name not same");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateItemForRow_ShouldCreateSyndicationItemWithExpectedValuesApproved()
        {
            // arrange
            var creator =
                new DraftContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.ApprovedContract, xml => true);

            //act
            var result = creator.CreateItemForRow(item, "Application/json");

            // assert
            Assert.AreEqual(contract.ToString(), result.Summary.Text, "Summary not same");
            Assert.AreEqual($"uuid:{item.Identifier}", result.Id, "Id not same");
            Assert.AreEqual($"Contract {item.BusinessKey} was Published to Provider", result.Title.Text, "Title not same");
            Assert.AreEqual("A contract has been Published to Provider", result.Categories[0].Label, "Label not same");
            Assert.AreEqual("Contract Published to Provider", result.Categories[0].Name, "Name not same");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateItemForRow_ShouldCreateSyndicationItemWithExpectedValuesContractTerminationDetailsUpdated()
        {
            // arrange
            var creator =
                new ContractTerminationDetailsUpdatedAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.ContractTerminationDetailsUpdated, xml => true);

            //act
            var result = creator.CreateItemForRow(item, "Application/json");

            // assert
            Assert.AreEqual(contract.ToString(), result.Summary.Text, "Summary not same");
            Assert.AreEqual($"uuid:{item.Identifier}", result.Id, "Id not same");
            Assert.AreEqual($"Termination details for contract {item.BusinessKey} have been updated", result.Title.Text, "Title not same");
            Assert.AreEqual("Termination details for a contract have been updated", result.Categories[0].Label, "Label not same");
            Assert.AreEqual("Contract Termination Details Updated", result.Categories[0].Name, "Name not same");
        }

        private CrossDomain.Integration.Entities.CorporateContract.contract GetCorpContract()
        {
            using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream($"ContractManagementService.Tests.Resources.masterContract.xml");
            var document = XDocument.Load(stream);

            XmlSerializer serializer =
                new XmlSerializer(typeof(CrossDomain.Integration.Entities.CorporateContract.contract));
            return
                (CrossDomain.Integration.Entities.CorporateContract.contract)
                    serializer.Deserialize(document.Root.CreateReader());
        }
    }
}
