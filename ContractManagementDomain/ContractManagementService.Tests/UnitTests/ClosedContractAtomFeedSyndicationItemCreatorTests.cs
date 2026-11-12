namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    public class ClosedContractAtomFeedSyndicationItemCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGetSummaryTextForCountractInCorrectFormat()
        {
            // arrange
            ClosedContractAtomFeedSyndicationItemCreator creator =
                new ClosedContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();

            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.ClosedContract, xml => true);

            // act
            string summaryText = creator.GetSummaryText(item);

            // assert
            Assert.AreEqual(contract.ToString(), summaryText);
        }

        private CrossDomain.Integration.Entities.CorporateContract.Contract GetCorpContract()
        {
            using var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"SFA.FCT.ContractManagementService.Tests.Resources.masterContract.xml");
            var document = XDocument.Load(stream);

            XmlSerializer serializer =
                    new XmlSerializer(typeof(CrossDomain.Integration.Entities.CorporateContract.Contract));
                return
                    (CrossDomain.Integration.Entities.CorporateContract.Contract)
                        serializer.Deserialize(document.Root.CreateReader());
        }
    }
}