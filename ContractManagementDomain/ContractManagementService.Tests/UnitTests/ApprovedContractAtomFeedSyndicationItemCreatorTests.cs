namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ApprovedContractAtomFeedSyndicationItemCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGetSummaryTextForCountractInCorrectFormat()
        {
            // arrange
            ApprovedContractAtomFeedSyndicationItemCreator creator =
                new ApprovedContractAtomFeedSyndicationItemCreator("Application/json");
            CrossDomain.Integration.Entities.CorporateContract.Contract contract = GetCorpContract();
      
            AtomFeedItem item = AtomFeedItem.CreateAtomFeedItem(contract, "Some key", AtomItemType.ApprovedContract, xml => true);

            // act
            string summaryText = creator.GetSummaryText(item);

            // assert
            Assert.AreEqual(contract.ToString(), summaryText);
        }

        private CrossDomain.Integration.Entities.CorporateContract.Contract GetCorpContract()
        {
            using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("ContractManagementService.Tests.Resources.masterContract.xml");
            var document = XDocument.Load(stream);

            XmlSerializer serializer =
                    new XmlSerializer(typeof (CrossDomain.Integration.Entities.CorporateContract.Contract));
                return
                    (CrossDomain.Integration.Entities.CorporateContract.Contract)
                        serializer.Deserialize(document.Root.CreateReader());
        }
    }
}
