namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using AtomFeed;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Common.PagedStorage;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.DataStore.Models;
    using PerformanceManagementDomain.DataStore.Repositories.Atom;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.AspNetCore;
    using Microsoft.AspNetCore.Hosting;
    using Microsoft.AspNetCore.TestHost;

    [TestClass]
    public class FcrFeedHyperlinkTests
    {
        private IServiceProvider _container;

        private const string ContractFeedId = "uuid:3ceb1ad6-94d5-4704-aeee-0f560fdb688b";
        private const string RouteSuffix = "notifications";

        private const string MediaType = "application/vnd.sfa.fundingclaimreconciliation.v1+atom+xml";
        private const string FeedTitle = "Funding Claim Reconciliation Notifications";
        private const string FeedAuthor = "Funding Claim Reconciliation Service";
        private const string RoutePrefix = "api/performance-management/funding-claim-reconciliations";

        private const string FeedBaseUrl = "http://localhost:45109";
        private IPageNumberMutator _pageNumberMutator;
        private Mock<IAtomFeedItemQueryRepository> _fcrAtomFeedItemQueryRepository;

        private readonly List<AtomFeedItem> _contractItems = new List<AtomFeedItem>
            {
                new AtomFeedItem(AtomItemType.Published, 02345678, "Claim0", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 12345678, "Claim1", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 22345678, "Claim2", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 32345678, "Claim3", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 42345678, "Claim4", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 52345678, "Claim5", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 62345678, "Claim6", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 72345678, "Claim7", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 82345678, "Claim8", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
                new AtomFeedItem(AtomItemType.Published, 92345678, "Claim9", "AllocGroup", "1516", "<?xml version=\"1.0\"?><string />"),
            };

        [TestInitialize]
        public void Setup()
        {
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock
                .Setup(m => m.CreateLogger(It.IsAny<string>()))
                .Returns(Mock.Of<ILogger>());
            
            SetupIoC();

            _pageNumberMutator = _container.GetService<IPageNumberMutator>();
            _fcrAtomFeedItemQueryRepository = new Mock<IAtomFeedItemQueryRepository>();


            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetEntitiesForPage(It.IsAny<int>()))
                                               .Returns(
                                                   new StoragePage<AtomFeedItem>
                                                   {
                                                       PageNumber = 2,
                                                       Rows = _contractItems
                                                   });
            _fcrAtomFeedItemQueryRepository.Setup(m => m.PageSize).Returns(10);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrFeedGenerator_PenultimatePage_ShouldNotHaveNextLink()
        {
            // arrange
            SetupIoC();
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns((int?)null);
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetFcrResultSet(2, _fcrAtomFeedItemQueryRepository.Object, RouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, FeedTitle, FeedAuthor, new FundingClaimReconciliationFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsFalse(feed.Links.Any(p => p.RelationshipType == "next-archive"), "Penultimate page contains next-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrFeedGenerator_TwoPagesBack_ShouldHaveNextLink()
        {
            // arrange
            SetupIoC();
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns(3);
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetFcrResultSet(2, _fcrAtomFeedItemQueryRepository.Object, RouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, FeedTitle, FeedAuthor, new FundingClaimReconciliationFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsTrue(feed.Links.Any(p => p.RelationshipType == "next-archive"), "Page does not contain next-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrFeedGenerator_LatestPage_ShouldNotHaveNextLink()
        {
            // arrange
            SetupIoC();
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns((int?)null);
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetFcrResultSet(2, _fcrAtomFeedItemQueryRepository.Object, RouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, FeedTitle, FeedAuthor, new FundingClaimReconciliationFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsFalse(feed.Links.Any(p => p.RelationshipType == "next-archive"), "Latest Page contains next-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrFeedGenerator_LatestPage_ShouldHavePrevLink()
        {
            // arrange
            SetupIoC();
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns((int?)null);
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetFcrResultSet(2, _fcrAtomFeedItemQueryRepository.Object, RouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, FeedTitle, FeedAuthor, new FundingClaimReconciliationFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsTrue(feed.Links.Any(p => p.RelationshipType == "prev-archive"), "Page does not contain prev-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrFeedGenerator_ArchivedPageNotFirst_ShouldHavePrevLink()
        {
            // arrange
            SetupIoC();
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns(3);
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetFcrResultSet(2, _fcrAtomFeedItemQueryRepository.Object, RouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, FeedTitle, FeedAuthor, new FundingClaimReconciliationFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsTrue(feed.Links.Any(p => p.RelationshipType == "prev-archive"), "Page does not contain prev-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FcrFeedGenerator_FirstPage_ShouldNotHavePrevLink()
        {
            // arrange
            SetupIoC();
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns(2);
            _fcrAtomFeedItemQueryRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns((int?)null);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetFcrResultSet(1, _fcrAtomFeedItemQueryRepository.Object, RouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, FeedTitle, FeedAuthor, new FundingClaimReconciliationFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsFalse(feed.Links.Any(p => p.RelationshipType == "prev-archive"), "First Page contains prev-archive link");
        }

        private static AtomFeed.PageStorageResultSet<AtomFeedItem> GetFcrResultSet(int? requestedPageNumber,
                                                                          IAtomFeedItemQueryRepository repository,
                                                                          string routeSuffix)
        {
            var pageStorageResultSet = new AtomFeed.PageStorageResultSet<AtomFeedItem> { PageNumber = requestedPageNumber };

            try
            {
                pageStorageResultSet.NextPageNumber = repository.GetNextPageNumber(requestedPageNumber);

                // ReSharper disable once SuggestVarOrType_Elsewhere
                StoragePage<AtomFeedItem> storagePage = pageStorageResultSet.PageNumber == null
                    ? repository.GetEntitiesForLatestPage()
                    : repository.GetEntitiesForPage(pageStorageResultSet.PageNumber.Value);

                pageStorageResultSet.PrevPageNumber = repository.GetPreviousPageNumber(storagePage.PageNumber);
                pageStorageResultSet.MediaType = MediaType;

                pageStorageResultSet.Rows = storagePage.Rows;
                if (storagePage.Rows.Any())
                {
                    pageStorageResultSet.LatestRowUpdatedTime =
                        storagePage.Rows.OrderByDescending(e => e.CreatedDate).First().CreatedDate;
                }

                pageStorageResultSet.Host = FeedBaseUrl;
                pageStorageResultSet.PageSize = repository.PageSize;

                pageStorageResultSet.RoutePrefix = RoutePrefix;
                pageStorageResultSet.RouteSuffix = routeSuffix;
            }
            catch (ArgumentOutOfRangeException)
            {
                throw new ArgumentException();
            }

            return pageStorageResultSet;
        }

        protected void SetupIoC()
        {
            var server = new TestServer(
                WebHost.CreateDefaultBuilder()
                    .UseStartup<Startup>()
            );
            _container = server.Host.Services;
        }
    }
}