namespace SFA.FCT.ContractManagementService.Test.UnitTests
{
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Controllers;
    using global::ContractManagementService.AtomFeed;
    using global::ContractManagementService.AtomFeed.EntryContent;
    using AtomRelationship = CrossDomain.Integration.Common.Atom.AtomRelationship;

    [TestClass]
    public class ContractAtomFeedGeneratorTests
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

            AtomFeed.PageStorageResultSet<contract> pageStorageResultSet = CreateContractsResultSet(contracts);
            pageStorageResultSet.Rows = contracts;
            var syndicationItemCreator = new SyndicationItemCreator<contract, ContractEntryContent>();

            // act
            SyndicationFeed feed = new AtomFeed.AtomFeedGenerator<contract>().GenerateFeed(pageStorageResultSet, null, "Title", "Author", syndicationItemCreator);

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

            AtomFeed.PageStorageResultSet<contract> pageStorageResultSet = CreateContractsResultSet(contracts);
            pageStorageResultSet.PageNumber = 1;
            pageStorageResultSet.NextPageNumber = 2;
            var syndicationItemCreator = new SyndicationItemCreator<contract, ContractEntryContent>();

            // act
            SyndicationFeed feed = new AtomFeed.AtomFeedGenerator<contract>().GenerateFeed(pageStorageResultSet, null, "Title", "Author", syndicationItemCreator);

            // assert
            Assert.IsTrue(feed.Links.Count(l => l.RelationshipType == AtomRelationship.PreviousRelationship) == 0);
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

            AtomFeed.PageStorageResultSet<contract> pageStorageResultSet = CreateContractsResultSet(contracts);
            pageStorageResultSet.Host = "http://localhost:45109";
            pageStorageResultSet.PageNumber = 0;
            pageStorageResultSet.NextPageNumber = 1;
            pageStorageResultSet.RoutePrefix = ContractNotificationFeedController.RoutePrefix;
            pageStorageResultSet.RouteSuffix = ContractNotificationFeedController.ContractApprovalRouteSuffix;
            string nextPageUrl = pageStorageResultSet.Host + "/" + ContractNotificationFeedController.RoutePrefix + "/" +
                                    ContractNotificationFeedController.ContractApprovalRouteSuffix + "/" + "2";
            var syndicationItemCreator = new SyndicationItemCreator<contract, ContractEntryContent>();

            // act
            SyndicationFeed feed = new AtomFeed.AtomFeedGenerator<contract>().GenerateFeed(pageStorageResultSet, null, "Title", "Author", syndicationItemCreator);

            // assert
            Assert.IsTrue(feed.Links.Count(l => l.RelationshipType == AtomRelationship.NextRelationship) == 1, "There is no next relationship");
            Assert.AreEqual(nextPageUrl, feed.Links.First(l => l.RelationshipType == AtomRelationship.NextRelationship).Uri.AbsoluteUri, "The url is wrong");
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

            AtomFeed.PageStorageResultSet<contract> pageStorageResultSet = CreateContractsResultSet(contracts);
            pageStorageResultSet.Host = "http://localhost:45109";
            pageStorageResultSet.PageNumber = 4;
            pageStorageResultSet.NextPageNumber = 3;
            pageStorageResultSet.PrevPageNumber = 2;
            var syndicationItemCreator = new SyndicationItemCreator<contract, ContractEntryContent>();

            // act
            SyndicationFeed feed = new AtomFeed.AtomFeedGenerator<contract>().GenerateFeed(pageStorageResultSet, null, "Title", "Author", syndicationItemCreator);

            // assert
            Assert.IsTrue(feed.Links.Count(l => l.RelationshipType == AtomRelationship.PreviousRelationship) == 1);
            Assert.IsTrue(feed.Links.Count(l => l.RelationshipType == AtomRelationship.NextRelationship) == 1);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldGenerateAFeedWithWhereEachItemHasTheContractNumberAndVersionInTheSummary()
        {
            // arrange
            IList<contract> contracts = new List<contract>();
            contracts.Add(new contract
            {
                contractor = new contractor()
            });

            contracts[0].contracts.Add(new contractType
            {
                 contractNumber = "XXX",
                contractVersionNumber = 2
            });

            AtomFeed.PageStorageResultSet<contract> pageStorageResultSet = CreateContractsResultSet(contracts);
            pageStorageResultSet.Host = "http://localhost:45109";
            pageStorageResultSet.PageNumber = 1;
            pageStorageResultSet.RoutePrefix = ContractNotificationFeedController.RoutePrefix;
            pageStorageResultSet.RouteSuffix = ContractNotificationFeedController.ContractApprovalRouteSuffix;
            var syndicationItemCreator = new SyndicationItemCreator<contract, ContractEntryContent>();

            // act
            SyndicationFeed feed = new AtomFeed.AtomFeedGenerator<contract>().GenerateFeed(pageStorageResultSet, null, "Title", "Author", syndicationItemCreator);

            // assert
            Assert.IsTrue(feed.Items.Count() == 1);
            Assert.IsTrue(feed.Items.First().Summary.Text == "{UKPRN: 0, contractNumber: XXX, version: 2}");
        }

        private AtomFeed.PageStorageResultSet<contract> CreateContractsResultSet(IList<contract> contracts)
        {
            var pageStorageResultSet = new AtomFeed.PageStorageResultSet<contract>();
            pageStorageResultSet.Rows = contracts;
            
            pageStorageResultSet.PageSize = 10;
            
            pageStorageResultSet.Host = "http://localhost:45109";
            pageStorageResultSet.RoutePrefix = ContractNotificationFeedController.RoutePrefix;
            pageStorageResultSet.RouteSuffix = ContractNotificationFeedController.ContractApprovalRouteSuffix;

            return pageStorageResultSet;
        }
    }
}
