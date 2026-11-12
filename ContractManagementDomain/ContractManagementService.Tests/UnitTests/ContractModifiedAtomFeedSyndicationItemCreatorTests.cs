namespace SFA.FCT.ContractManagementService.Tests.UnitTests
{
    using System.Reflection;
    using System.ServiceModel.Syndication;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractModifiedAtomFeedSyndicationItemCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractModifiedAtomFeedSyndicationItemCreator_ShouldCreateSyndicationItemWithExpectedValues()
        {
            // arrange
            ContractModifiedAtomFeedSyndicationItemCreator creator = new ContractModifiedAtomFeedSyndicationItemCreator("application/json");
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();
            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "BUSINESS-KEY", AtomItemType.ContractModified, xml => true);

            // act
            SyndicationItem result = creator.CreateItemForRow(item, "application/json");

            // assert
            Assert.AreEqual(contract.ToString(), result.Summary.Text, "Summary incorrect");
            Assert.AreEqual($"uuid:{item.Identifier}", result.Id, "Id incorrect");
            Assert.AreEqual($"Contract {item.BusinessKey} was modified", result.Title.Text, "Title incorrect");
            Assert.AreEqual("Contract Modified", result.Categories[0].Name, "Name incorrect");
            Assert.AreEqual("Contract has been modified", result.Categories[0].Label, "Label incorrect");
        }

        private static CrossDomain.Integration.Entities.CorporateContract.Contract GetCorpContract()
        {
            using var stream = Assembly.GetCallingAssembly().GetManifestResourceStream("ContractManagementService.Tests.Resources.masterContract.xml");
            var document = XDocument.Load(stream);
            XmlSerializer serializer = new XmlSerializer(typeof(CrossDomain.Integration.Entities.CorporateContract.Contract));
                
                return (CrossDomain.Integration.Entities.CorporateContract.Contract)serializer.Deserialize(document.Root.CreateReader());
        }
    }
}
