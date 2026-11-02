namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class DraftContractAtomFeedSyndicationItemCreatorTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGetSummaryTextForCountractInCorrectFormat()
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
        public void CreateItemForRow_ShouldCreateSyndicationItemWithExpectedValues()
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


        private CrossDomain.Integration.Entities.CorporateContract.contract GetCorpContract()
        {
            using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("ContractManagementService.Tests.Resources.masterContract.xml");
            var document = XDocument.Load(stream);

            XmlSerializer serializer =
                    new XmlSerializer(typeof(CrossDomain.Integration.Entities.CorporateContract.contract));
                return
                    (CrossDomain.Integration.Entities.CorporateContract.contract)
                        serializer.Deserialize(document.Root.CreateReader());
        }
    }
}
