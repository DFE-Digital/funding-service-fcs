namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Linq;

    [TestClass]
    public class FundingPolicyTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGenerateAFeedWithTheCorrectNumberOfItems()
        {
            // arrange
            const int numContracts = 10;
            IList<contract> contracts = new List<contract>();
            for (int i = 0; i < numContracts; i++)
            {
                contracts.Add(new contract());
            }

            ContractsResultSet contractsResultSet = CreateContractsResultSet(contracts);
            contractsResultSet.Contracts = contracts;

            // act
            SyndicationFeed feed = new ContractAtomFeedGenerator().GenerateFeed(contractsResultSet, Notification.Approved);

            // assert
            Assert.IsTrue(feed.Items.Count() == numContracts);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGenerateAFeedWithNoPrevLinkWhenRequestingTheFirstPage()
        {
            // arrange
            const int numContracts = 10;
            IList<contract> contracts = new List<contract>();
            for (int i = 0; i < numContracts; i++)
            {
                contracts.Add(new contract());
            }

            ContractsResultSet contractsResultSet = CreateContractsResultSet(contracts);
            contractsResultSet.PageNumber = 1;
            contractsResultSet.NextPageNumber = 2;

            // act
            SyndicationFeed feed = new ContractAtomFeedGenerator().GenerateFeed(contractsResultSet, Notification.Approved);

            // assert
            Assert.IsTrue(feed.Links.Count(l => l.RelationshipType == ContractAtomFeedGenerator.PreviousRelationship) == 0);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGenerateAFeedWithNextLinkWhenRequestingTheFirstPageWithMorePagesAvailable()
        {
            // arrange
            const int numContracts = 10;
            IList<contract> contracts = new List<contract>();
            for (int i = 0; i < numContracts; i++)
            {
                contracts.Add(new contract());
            }

            ContractsResultSet contractsResultSet = CreateContractsResultSet(contracts);
            contractsResultSet.Host = "http://localhost:45109";
            contractsResultSet.PageNumber = 1;
            contractsResultSet.NextPageNumber = 2;
            string nextPageUrl = contractsResultSet.Host + "/" + ContractNotificationFeedController.RoutePrefix + "/" +
                                    ContractNotificationFeedController.ContractApprovalRouteSuffix + "/" + contractsResultSet.NextPageNumber.ToString();
            // act
            SyndicationFeed feed = new ContractAtomFeedGenerator().GenerateFeed(contractsResultSet, Notification.Approved);

            // assert
            Assert.IsTrue(feed.Links.Count(l => l.RelationshipType == ContractAtomFeedGenerator.NextRelationship) == 1);
            Assert.IsTrue(feed.Links.First(l => l.RelationshipType == ContractAtomFeedGenerator.NextRelationship).Uri.AbsoluteUri == nextPageUrl);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGenerateAFeedWithPrevAndNextLinkWhenRequestingTheAMiddlePage()
        {
            // arrange
            const int numContracts = 10;
            IList<contract> contracts = new List<contract>();
            for (int i = 0; i < numContracts; i++)
            {
                contracts.Add(new contract());
            }

            ContractsResultSet contractsResultSet = CreateContractsResultSet(contracts);
            contractsResultSet.Host = "http://localhost:45109";
            contractsResultSet.PageNumber = 4;
            contractsResultSet.NextPageNumber = 3;
            contractsResultSet.PrevPageNumber = 2;

            // act
            SyndicationFeed feed = new ContractAtomFeedGenerator().GenerateFeed(contractsResultSet, Notification.Approved);

            // assert
            Assert.IsTrue(feed.Links.Count(l => l.RelationshipType == ContractAtomFeedGenerator.PreviousRelationship) == 1);
            Assert.IsTrue(feed.Links.Count(l => l.RelationshipType == ContractAtomFeedGenerator.NextRelationship) == 1);
        }

        private ContractsResultSet CreateContractsResultSet(IList<contract> contracts)
        {
            ContractsResultSet contractsResultSet = new ContractsResultSet();
            contractsResultSet.Contracts = contracts;
            
            contractsResultSet.PageSize = 10;
            
            contractsResultSet.Host = "http://localhost:45109";

            return contractsResultSet;
        }
    }
}
