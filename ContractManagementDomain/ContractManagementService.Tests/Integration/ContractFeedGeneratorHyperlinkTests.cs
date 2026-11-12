namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Framework.Logging.Interfaces;
    using Microsoft.AspNetCore;
    using Microsoft.AspNetCore.Hosting;
    using Microsoft.AspNetCore.TestHost;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Xml.Linq;
    using System.Xml.Serialization;

    [TestClass]
    public class ContractFeedGeneratorHyperlinkTests
    {
        private IServiceProvider _container;

        private const string ContractFeedId = "uuid:12537fce-65bc-4f58-bb2d-183f8c3ad069";
        private const string ContractFeedTitle = "Contract Management Approved Contract Notifications";
        private const string ContractFeedAuthor = "Contract Management Service";
        private const string MediaType = "application/vnd.sfa.contract.v1+atom+xml";
        private const string ContractApprovalRouteSuffix = "approvals";
        private const string ContractRoutePrefix = "api/contracts/notifications";
        private const string ContractUrl = "http://localhost:45109";
        private IPageNumberMutator _pageNumberMutator;
        private Mock<IApprovedContractAtomItemRepository> _contractApprovedAtomItemRepository;

        private readonly List<AtomFeedItem> _contractItems = new List<AtomFeedItem>
            {
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-0", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-1", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-2", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-3", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-4", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-5", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-6", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-7", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-8", AtomItemType.ApprovedContract, xml => true),
                AtomFeedItem.CreateAtomFeedItem(GetCorpContract(), "Test-9", AtomItemType.ApprovedContract, xml => true)
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
            _contractApprovedAtomItemRepository = new Mock<IApprovedContractAtomItemRepository>();

            
            _contractApprovedAtomItemRepository.Setup(m => m.GetEntitiesForPage(It.IsAny<int>()))
                                               .Returns(
                                                   new StoragePage<AtomFeedItem>
                                                   {
                                                       PageNumber = 2,
                                                       Rows = _contractItems
                                                   });
            _contractApprovedAtomItemRepository.Setup(m => m.PageSize).Returns(10);
        }

        private void SetupIoC()
        {
            var server = new TestServer(
                WebHost.CreateDefaultBuilder()
                    .UseStartup<Startup>()
            );
            _container = server.Host.Services;
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractFeedGenerator_PenultimatePage_ShouldNotHaveNextLink()
        {
            // arrange
            _contractApprovedAtomItemRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns((int?)null);
            _contractApprovedAtomItemRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetContractsResultSet(2, _contractApprovedAtomItemRepository.Object, ContractApprovalRouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, ContractFeedTitle, ContractFeedAuthor, new ApprovedContractAtomFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsFalse(feed.Links.Any(p => p.RelationshipType == "next-archive"), "Penultimate page contains next-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractFeedGenerator_TwoPagesBack_ShouldHaveNextLink()
        {
            // arrange
            _contractApprovedAtomItemRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns(3);
            _contractApprovedAtomItemRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetContractsResultSet(2, _contractApprovedAtomItemRepository.Object, ContractApprovalRouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, ContractFeedTitle, ContractFeedAuthor, new ApprovedContractAtomFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsTrue(feed.Links.Any(p => p.RelationshipType == "next-archive"), "Page does not contain next-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractFeedGenerator_LatestPage_ShouldNotHaveNextLink()
        {
            // arrange
            _contractApprovedAtomItemRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns((int?)null);
            _contractApprovedAtomItemRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetContractsResultSet(2, _contractApprovedAtomItemRepository.Object, ContractApprovalRouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, ContractFeedTitle, ContractFeedAuthor, new ApprovedContractAtomFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsFalse(feed.Links.Any(p => p.RelationshipType == "next-archive"), "Latest Page contains next-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractFeedGenerator_LatestPage_ShouldHavePrevLink()
        {
            // arrange
            _contractApprovedAtomItemRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns((int?)null);
            _contractApprovedAtomItemRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetContractsResultSet(2, _contractApprovedAtomItemRepository.Object, ContractApprovalRouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, ContractFeedTitle, ContractFeedAuthor, new ApprovedContractAtomFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsTrue(feed.Links.Any(p => p.RelationshipType == "prev-archive"), "Page does not contain prev-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractFeedGenerator_ArchivedPageNotFirst_ShouldHavePrevLink()
        {
            // arrange
            _contractApprovedAtomItemRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns(3);
            _contractApprovedAtomItemRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns(1);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetContractsResultSet(2, _contractApprovedAtomItemRepository.Object, ContractApprovalRouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, ContractFeedTitle, ContractFeedAuthor, new ApprovedContractAtomFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsTrue(feed.Links.Any(p => p.RelationshipType == "prev-archive"), "Page does not contain prev-archive link");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractFeedGenerator_FirstPage_ShouldNotHavePrevLink()
        {
            // arrange
            _contractApprovedAtomItemRepository.Setup(m => m.GetNextPageNumber(It.IsAny<int?>())).Returns(2);
            _contractApprovedAtomItemRepository.Setup(m => m.GetPreviousPageNumber(It.IsAny<int>())).Returns((int?)null);
            AtomFeed.IAtomFeedGenerator<AtomFeedItem> feedGenerator =
                _container.GetService<AtomFeed.IAtomFeedGenerator<AtomFeedItem>>();
            var resultSet = GetContractsResultSet(1, _contractApprovedAtomItemRepository.Object, ContractApprovalRouteSuffix);
            var feedId = ContractFeedId;

            // act
            var feed = feedGenerator.GenerateFeed(resultSet, feedId, ContractFeedTitle, ContractFeedAuthor, new ApprovedContractAtomFeedSyndicationItemCreator(MediaType));

            // assert
            Assert.IsFalse(feed.Links.Any(p => p.RelationshipType == "prev-archive"), "First Page contains prev-archive link");
        }

        private static AtomFeed.PageStorageResultSet<AtomFeedItem> GetContractsResultSet(int? requestedPageNumber, IAtomItemQueryRepository repository, string routeSuffix)
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

                pageStorageResultSet.Host = ContractUrl;
                pageStorageResultSet.PageSize = repository.PageSize;

                pageStorageResultSet.RoutePrefix = ContractRoutePrefix;
                pageStorageResultSet.RouteSuffix = routeSuffix;
            }
            catch (ArgumentOutOfRangeException)
            {
                throw new ArgumentException();
            }

            return pageStorageResultSet;
        }

        private static Contract GetCorpContract()
        {
            using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("ContractManagementService.Tests.Resources.masterContract.xml");
           
            var document = XDocument.Load(stream);

            XmlSerializer serializer =
                new XmlSerializer(typeof(Contract));
            return
                (Contract)
                serializer.Deserialize(document.Root.CreateReader());
        }
    }
}