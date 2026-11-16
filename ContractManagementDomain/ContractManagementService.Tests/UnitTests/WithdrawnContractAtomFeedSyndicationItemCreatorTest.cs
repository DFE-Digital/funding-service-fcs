namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class WithdrawnContractAtomFeedSyndicationItemCreatorTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGetSummaryTextForCountractInCorrectFormat()
        {
            // arrange
            var creator =
                new DraftContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.WithdrawnContract, xml => true);

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
                new WithdrawnContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.WithdrawnContract, xml => true);
          
            //act
            var result = creator.CreateItemForRow(item, "Application/json");

            // assert
            Assert.AreEqual(contract.ToString(), result.Summary.Text, "Summary not same");
            Assert.AreEqual($"uuid:{item.Identifier}", result.Id,"Id not same");
            Assert.AreEqual($"Contract {item.BusinessKey} was Withdrawn", result.Title.Text, "Title not same");
            Assert.AreEqual("A contract has been Withdrawn", result.Categories[0].Label, "Label not same");
            Assert.AreEqual("Contract Withdrawn", result.Categories[0].Name, "Name not same");
        }


        private CrossDomain.Integration.Entities.CorporateContract.Contract GetCorpContract()
        {
            using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("ContractManagementService.Tests.Resources.masterContract.xml");
            var document = XDocument.Load(stream);

            XmlSerializer serializer =
                    new XmlSerializer(typeof(CrossDomain.Integration.Entities.CorporateContract.Contract));
                return
                    (CrossDomain.Integration.Entities.CorporateContract.Contract)
                        serializer.Deserialize(document.Root.CreateReader());
        }
    }
}
