using System;
using System.ServiceModel.Syndication;
using System.Threading.Tasks;
using ContractManagement.DataStore.Repositories;
using ContractManagementService.AtomFeed;
using SFA.FCT.ContractManagementService.Controllers.PaymentRequestAtomFeed;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using PaymentGenerationDomain.Integration.DataStore.Repositories;
using SFA.FCS.Worker.Common;
using SFA.FCT.ContractManagementService.Controllers;
using SFA.FCT.CrossDomain.Integration.Common.Atom;
using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
using ContractFeedItem = ContractManagement.DataStore.Model.AtomFeedItem;
using ContractFeedGenerator = SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<ContractManagement.DataStore.Model.AtomFeedItem>;
using PaymentFeedItem = PaymentGenerationDomain.Integration.DataStore.Model.PaymentBatchFeedItem;
using PaymentFeedGenerator = SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<PaymentGenerationDomain.Integration.DataStore.Model.PaymentBatchFeedItem>;
using PerfFeedItem = SFA.FCT.PerformanceManagementDomain.DataStore.Models.AtomFeedItem;
using PerfFeedGenerator = SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<SFA.FCT.PerformanceManagementDomain.DataStore.Models.AtomFeedItem>;
using PerfRepository = SFA.FCT.PerformanceManagementDomain.DataStore.Repositories.Atom.IAtomFeedItemQueryRepository;

namespace ContractManagementService.Tests.UnitTests.FeedControllers
{
    [TestClass, TestCategory("UnitTest")]
    public class ContractNotificationFeedControllerTests
    {
        private Mock<IApprovedContractAtomItemRepository> _approved;
        private Mock<IDraftContractAtomItemRepository> _draft;
        private Mock<IAllContractAtomItemRepository> _all;
        private Mock<IApprovalOnwardsContractAtomItemRepository> _onwards;
        private Mock<ContractFeedGenerator> _generator;
        private Mock<IPageNumberMutator> _mutator;
        private Mock<IFcsConfiguration> _config;
        private ContractNotificationFeedController _controller;

        [TestInitialize]
        public void Setup()
        {
            _approved = new Mock<IApprovedContractAtomItemRepository>();
            _draft = new Mock<IDraftContractAtomItemRepository>();
            _all = new Mock<IAllContractAtomItemRepository>();
            _onwards = new Mock<IApprovalOnwardsContractAtomItemRepository>();
            _generator = new Mock<ContractFeedGenerator>();
            _mutator = new Mock<IPageNumberMutator>();
            _mutator.Setup(m => m.MutatePageNumberIn(It.IsAny<int>())).Returns<int>(p => p - 1);
            _config = new Mock<IFcsConfiguration>();
            _config.Setup(c => c[It.IsAny<string>()]).Returns("value");

            foreach (var repo in new[] { _approved.As<IAtomItemQueryRepository>(), _draft.As<IAtomItemQueryRepository>(), _all.As<IAtomItemQueryRepository>(), _onwards.As<IAtomItemQueryRepository>() })
            {
                repo.Setup(r => r.GetEntitiesForLatestPage()).Returns(new StoragePage<ContractFeedItem>());
                repo.Setup(r => r.GetEntitiesForPage(It.IsAny<int>())).Returns(new StoragePage<ContractFeedItem>());
                repo.SetupGet(r => r.PageSize).Returns(10);
            }

            _generator
                .Setup(g => g.GenerateFeed(It.IsAny<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<ContractFeedItem>>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ISyndicationItemCreator<ContractFeedItem>>(), It.IsAny<bool>()))
                .Returns(new SyndicationFeed());

            _controller = new ContractNotificationFeedController(_approved.Object, _generator.Object, _mutator.Object, _draft.Object, _all.Object, _onwards.Object, _config.Object)
            {
                ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext() }
            };
        }

        [TestMethod]
        public void LatestPages_ReturnOkWithFeed()
        {
            Assert.IsInstanceOfType(_controller.GetLatestApprovedContractsPage(), typeof(OkObjectResult));
            Assert.IsInstanceOfType(_controller.GetLatestAllContractsPage(), typeof(OkObjectResult));
            Assert.IsInstanceOfType(_controller.GetLatestDraftContractsPage(), typeof(OkObjectResult));
            Assert.IsInstanceOfType(_controller.GetLatestApprovedOnwardsContractsPage(), typeof(OkObjectResult));
        }

        [TestMethod]
        public void LatestPage_EmptyFeed_SetsLastUpdatedToNow()
        {
            var result = (OkObjectResult)_controller.GetLatestAllContractsPage();

            var feed = (SyndicationFeed)result.Value;
            Assert.IsTrue(feed.LastUpdatedTime > DateTimeOffset.UtcNow.AddMinutes(-1));
        }

        [TestMethod]
        public void NumberedPages_ValidPage_ReturnOk()
        {
            Assert.IsInstanceOfType(_controller.GetApprovedContractsPage(2), typeof(OkObjectResult));
            Assert.IsInstanceOfType(_controller.GetAllContractsPage(2), typeof(OkObjectResult));
            Assert.IsInstanceOfType(_controller.GetDraftContractsPage(2), typeof(OkObjectResult));
            Assert.IsInstanceOfType(_controller.GetApprovedOnwardsContractsPage(2), typeof(OkObjectResult));
        }

        [TestMethod]
        public void NumberedPages_NegativePageAfterMutation_ReturnNotFound()
        {
            Assert.IsInstanceOfType(_controller.GetApprovedContractsPage(0), typeof(NotFoundResult));
            Assert.IsInstanceOfType(_controller.GetAllContractsPage(0), typeof(NotFoundResult));
            Assert.IsInstanceOfType(_controller.GetDraftContractsPage(0), typeof(NotFoundResult));
            Assert.IsInstanceOfType(_controller.GetApprovedOnwardsContractsPage(0), typeof(NotFoundResult));
        }

        [TestMethod]
        public void NumberedPage_RepositoryRejectsPage_ReturnsNotFound()
        {
            _all.As<IAtomItemQueryRepository>().Setup(r => r.GetNextPageNumber(It.IsAny<int?>())).Throws(new ArgumentOutOfRangeException());

            Assert.IsInstanceOfType(_controller.GetAllContractsPage(5), typeof(NotFoundResult));
        }
    }

    [TestClass, TestCategory("UnitTest")]
    public class FundingClaimReconciliationControllerTests
    {
        private Mock<PerfFeedGenerator> _generator;
        private Mock<PerfRepository> _repository;
        private Mock<IFcsConfiguration> _config;
        private FundingClaimReconciliationController _controller;

        [TestInitialize]
        public void Setup()
        {
            _generator = new Mock<PerfFeedGenerator>();
            _repository = new Mock<PerfRepository>();
            _config = new Mock<IFcsConfiguration>();
            _config.Setup(c => c[It.IsAny<string>()]).Returns("value");
            _repository.Setup(r => r.GetEntitiesForLatestPage()).Returns(new StoragePage<PerfFeedItem>());
            _repository.Setup(r => r.GetEntitiesForPage(It.IsAny<int>())).Returns(new StoragePage<PerfFeedItem>());
            _generator
                .Setup(g => g.GenerateFeed(It.IsAny<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<PerfFeedItem>>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ISyndicationItemCreator<PerfFeedItem>>(), It.IsAny<bool>()))
                .Returns(new SyndicationFeed());

            _controller = new FundingClaimReconciliationController(Mock.Of<SFA.FCT.Framework.Logging.Interfaces.ILogger>(), _generator.Object, _repository.Object, _config.Object)
            {
                ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext() }
            };
        }

        [TestMethod]
        public void Get_ReturnsAccepted()
        {
            Assert.IsInstanceOfType(_controller.Get(), typeof(AcceptedResult));
        }

        [TestMethod]
        public void GetLatestPage_ReturnsOk()
        {
            Assert.IsInstanceOfType(_controller.GetLatestFundingClaimReconciliationPage(), typeof(OkObjectResult));
        }

        [TestMethod]
        public void GetPage_ValidPage_ReturnsOk()
        {
            Assert.IsInstanceOfType(_controller.GetFundingClaimReconciliationPage(3), typeof(OkObjectResult));
        }

        [TestMethod]
        public void GetPage_PageZero_ReturnsNotFound()
        {
            Assert.IsInstanceOfType(_controller.GetFundingClaimReconciliationPage(0), typeof(NotFoundResult));
        }

        [TestMethod]
        public void GetPage_RepositoryRejectsPage_ThrowsArgumentException()
        {
            _repository.Setup(r => r.GetNextPageNumber(It.IsAny<int?>())).Throws(new ArgumentOutOfRangeException());

            Assert.ThrowsException<ArgumentException>(() => _controller.GetFundingClaimReconciliationPage(3));
        }
    }

    [TestClass, TestCategory("UnitTest")]
    public class PaymentRequestControllerTests
    {
        private Mock<IPaymentBatchFeedItemRepository> _repository;
        private Mock<PaymentFeedGenerator> _generator;
        private Mock<IFcsConfiguration> _config;
        private PaymentRequestController _controller;

        [TestInitialize]
        public void Setup()
        {
            _repository = new Mock<IPaymentBatchFeedItemRepository>();
            _generator = new Mock<PaymentFeedGenerator>();
            _config = new Mock<IFcsConfiguration>();
            _config.Setup(c => c[It.IsAny<string>()]).Returns("value");
            _repository.Setup(r => r.GetNextPageNumber(It.IsAny<int?>(), It.IsAny<int>())).ReturnsAsync((int?)null);
            _repository.Setup(r => r.GetEntitiesForLatestPage(It.IsAny<int>())).ReturnsAsync(new StoragePage<PaymentFeedItem>());
            _repository.Setup(r => r.GetEntitiesForPage(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(new StoragePage<PaymentFeedItem>());
            _generator
                .Setup(g => g.GenerateFeed(It.IsAny<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<PaymentFeedItem>>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ISyndicationItemCreator<PaymentFeedItem>>(), It.IsAny<bool>()))
                .Returns(new SyndicationFeed());

            _controller = new PaymentRequestController(_repository.Object, _generator.Object, _config.Object)
            {
                ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext() }
            };
        }

        [TestMethod]
        public async Task GetLatest_ReturnsOk()
        {
            Assert.IsInstanceOfType(await _controller.GetLatestPaymentRequestPage(), typeof(OkObjectResult));
        }

        [TestMethod]
        public async Task GetPage_ValidPage_ReturnsOk()
        {
            Assert.IsInstanceOfType(await _controller.GetPaymentRequestPage(2), typeof(OkObjectResult));
        }

        [TestMethod]
        public async Task GetPage_PageZero_ReturnsNotFound()
        {
            Assert.IsInstanceOfType(await _controller.GetPaymentRequestPage(0), typeof(NotFoundResult));
        }

        [TestMethod]
        public async Task GetPage_RepositoryRejectsPage_ThrowsArgumentException()
        {
            _repository.Setup(r => r.GetNextPageNumber(It.IsAny<int?>(), It.IsAny<int>())).ThrowsAsync(new ArgumentOutOfRangeException());

            await Assert.ThrowsExceptionAsync<ArgumentException>(() => _controller.GetPaymentRequestPage(2));
        }
    }
}
