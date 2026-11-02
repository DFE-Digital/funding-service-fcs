using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.ContractManagementService.AtomFeed;
using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    [TestClass]
    public class FundingClaimReconciliationFeedSyndicationItemCreatorTests
    {
        private AtomFeedItem _atomFeedItemUnderTest = new AtomFeedItem(AtomItemType.Published, 12345, "CTN", "AGN", "1516", "<XML></XML>");
        private string _mediaType = "application/vnd.sfa.fundingclaimreconciliation.v1+atom+xml";

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationFeedSyndicationItemCreator_SuccessfullyCreatesItemForRow()
        {
            // Arrange
            AtomFeedItem atomFeedItem = new AtomFeedItem(AtomItemType.Published, _atomFeedItemUnderTest.Ukprn, _atomFeedItemUnderTest.ClaimTypeName, _atomFeedItemUnderTest.AllocationGroupName, _atomFeedItemUnderTest.Period, _atomFeedItemUnderTest.AtomFeedItemXml);

            // Act
            var fundingClaimReconciliationFeedSyndicationItemCreator = new FundingClaimReconciliationFeedSyndicationItemCreator(_mediaType);
            var syndicationItem = fundingClaimReconciliationFeedSyndicationItemCreator.CreateItemForRow(atomFeedItem, _mediaType);

            // Assert
            Assert.IsNotNull(syndicationItem, "Item Not Created");
            Assert.AreEqual(syndicationItem.Title.Text,
                $"Funding Claim Reconciliation for Provider {_atomFeedItemUnderTest.Ukprn} for Claim Type {_atomFeedItemUnderTest.ClaimTypeName} and Allocation Group {_atomFeedItemUnderTest.AllocationGroupName} period {_atomFeedItemUnderTest.Period} is Published");
            Assert.AreEqual(syndicationItem.Summary.Text, $"{{UKPRN: {_atomFeedItemUnderTest.Ukprn}, Claim Type: {_atomFeedItemUnderTest.ClaimTypeName}, Allocation Group: {_atomFeedItemUnderTest.AllocationGroupName}, Period: {_atomFeedItemUnderTest.Period}}}");
            Assert.AreEqual(syndicationItem.Categories.Count, 1, "Category Not Added");
            Assert.AreEqual(syndicationItem.Categories[0].Name, "Funding Claim Reconciliation Published");
            Assert.AreEqual(syndicationItem.Categories[0].Label, "A funding claim reconciliation has been published");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void FundingClaimReconciliationFeedSyndicationItemCreator_ShowThrowCorrectException()
        {
            // Arrange
            AtomItemType newItem = (AtomItemType)999;
            AtomFeedItem atomFeedItem = new AtomFeedItem(newItem, _atomFeedItemUnderTest.Ukprn, _atomFeedItemUnderTest.ClaimTypeName, _atomFeedItemUnderTest.AllocationGroupName, _atomFeedItemUnderTest.Period, _atomFeedItemUnderTest.AtomFeedItemXml);

            // Act
            var fundingClaimReconciliationFeedSyndicationItemCreator = new FundingClaimReconciliationFeedSyndicationItemCreator(_mediaType);
            var syndicationItem = fundingClaimReconciliationFeedSyndicationItemCreator.CreateItemForRow(atomFeedItem, _mediaType);
        }
    }
}
