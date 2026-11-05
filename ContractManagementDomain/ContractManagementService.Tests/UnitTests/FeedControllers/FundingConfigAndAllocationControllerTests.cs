using System;
using System.Collections.Generic;
using System.ServiceModel.Syndication;
using System.Threading.Tasks;
using ContractManagementService.AtomFeed;
using ContractManagementService.AtomFeed.EntryContent;
using ContractManagementService.DTOs;
using ContractManagementService.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using SFA.FCS.Worker.Common;
using SFA.FCT.ContractManagementService.Controllers;
using SFA.FCT.ContractManagementService.Controllers.FundingConfigService;
using SFA.FCT.CrossDomain.Integration.Common.Atom;
using SFA.FCT.CrossDomain.Integration.Entities;
using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
using AllocationFeedGenerator = SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<ContractManagementService.DTOs.AllocationDeliveryEntry>;
using SettingFeedGenerator = SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<SFA.FCT.CrossDomain.Integration.Entities.DeliverableSettingConfiguration>;

namespace ContractManagementService.Tests.UnitTests.FeedControllers
{
    [TestClass, TestCategory("UnitTest")]
    public class AllocationNotificationFeedControllerTests
    {
        private Mock<AllocationFeedGenerator> _generator;
        private Mock<IPageNumberMutator> _mutator;
        private Mock<IAllocationDeliveryEntryQueryRepository> _repository;
        private Mock<IFcsConfiguration> _config;
        private AllocationNotificationFeedController _controller;
        private DefaultHttpContext _http;

        [TestInitialize]
        public void Setup()
        {
            _generator = new Mock<AllocationFeedGenerator>();
            _mutator = new Mock<IPageNumberMutator>();
            _mutator.Setup(m => m.MutatePageNumberIn(It.IsAny<int>())).Returns<int>(p => p - 1);
            _repository = new Mock<IAllocationDeliveryEntryQueryRepository>();
            _repository.Setup(r => r.GetEntitiesForLatestPage()).Returns(new StoragePage<AllocationDeliveryEntry>());
            _repository.Setup(r => r.GetEntitiesForPage(It.IsAny<int>())).Returns(new StoragePage<AllocationDeliveryEntry>());
            _config = new Mock<IFcsConfiguration>();
            _config.Setup(c => c[It.IsAny<string>()]).Returns("value");
            _generator
                .Setup(g => g.GenerateFeed(It.IsAny<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<AllocationDeliveryEntry>>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ISyndicationItemCreator<AllocationDeliveryEntry>>(), It.IsAny<bool>()))
                .Returns(new SyndicationFeed());
            _http = new DefaultHttpContext();
            _controller = new AllocationNotificationFeedController(_generator.Object, _mutator.Object, _repository.Object, _config.Object)
            {
                ControllerContext = new ControllerContext { HttpContext = _http }
            };
        }

        [TestMethod]
        public void GetLatest_NoNextPage_ReturnsOkWithNoCacheHeader()
        {
            var result = _controller.GetLatestAllocationDeliveryMonitoringPage();

            Assert.IsInstanceOfType(result, typeof(OkObjectResult));
            Assert.AreEqual("no-store,no-cache", _http.Response.Headers["Cache-Control"].ToString());
        }

        [TestMethod]
        public void GetPage_WithNextPage_SetsPublicCacheHeader()
        {
            _repository.Setup(r => r.GetNextPageNumber(It.IsAny<int?>())).Returns(5);

            var result = _controller.GetAllocationDeliveryMonitoringPage(2);

            Assert.IsInstanceOfType(result, typeof(OkObjectResult));
            StringAssert.StartsWith(_http.Response.Headers["Cache-Control"].ToString(), "public,max-age=");
        }

        [TestMethod]
        public void GetPage_NegativeAfterMutation_ReturnsNotFound()
        {
            Assert.IsInstanceOfType(_controller.GetAllocationDeliveryMonitoringPage(0), typeof(NotFoundResult));
        }

        [TestMethod]
        public void GetPage_RepositoryRejectsPage_ReturnsNotFound()
        {
            _repository.Setup(r => r.GetNextPageNumber(It.IsAny<int?>())).Throws(new ArgumentOutOfRangeException());

            Assert.IsInstanceOfType(_controller.GetAllocationDeliveryMonitoringPage(3), typeof(NotFoundResult));
        }

        [TestMethod]
        public void GetPage_WithRows_UsesLatestRowTimeAndForwardedHost()
        {
            var page = new StoragePage<AllocationDeliveryEntry>();
            page.Rows.Add(new AllocationDeliveryEntry { CreatedDate = new DateTime(2020, 1, 1) });
            page.Rows.Add(new AllocationDeliveryEntry { CreatedDate = new DateTime(2021, 1, 1) });
            _repository.Setup(r => r.GetEntitiesForPage(It.IsAny<int>())).Returns(page);
            _http.Request.Headers["X-Request-Host"] = "example.org";
            _http.Request.Headers["X-Request-Scheme"] = "https";
            SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<AllocationDeliveryEntry> captured = null;
            _generator
                .Setup(g => g.GenerateFeed(It.IsAny<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<AllocationDeliveryEntry>>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ISyndicationItemCreator<AllocationDeliveryEntry>>(), It.IsAny<bool>()))
                .Callback<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<AllocationDeliveryEntry>, string, string, string, ISyndicationItemCreator<AllocationDeliveryEntry>, bool>((rs, a, b, c, d, e) => captured = rs)
                .Returns(new SyndicationFeed());

            _controller.GetAllocationDeliveryMonitoringPage(2);

            Assert.AreEqual(new DateTime(2021, 1, 1), captured.LatestRowUpdatedTime);
            Assert.AreEqual("https://example.org", captured.Host);
        }
    }

    [TestClass, TestCategory("UnitTest")]
    public class DeliverableSettingConfigurationFeedControllerTests
    {
        private Mock<IPagedStorageQueryRepository<DeliverableSettingConfiguration>> _repository;
        private Mock<SettingFeedGenerator> _generator;
        private DeliverableSettingConfigurationFeedController _controller;

        [TestInitialize]
        public void Setup()
        {
            _repository = new Mock<IPagedStorageQueryRepository<DeliverableSettingConfiguration>>();
            _generator = new Mock<SettingFeedGenerator>();
            var config = new Mock<IFcsConfiguration>();
            config.Setup(c => c[It.IsAny<string>()]).Returns("value");
            _generator
                .Setup(g => g.GenerateFeed(It.IsAny<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<DeliverableSettingConfiguration>>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ISyndicationItemCreator<DeliverableSettingConfiguration>>(), It.IsAny<bool>()))
                .Returns(new SyndicationFeed());
            _controller = new DeliverableSettingConfigurationFeedController(_repository.Object, _generator.Object, config.Object);
        }

        private static StoragePage<DeliverableSettingConfiguration> Page(int number, int rows)
        {
            var page = new StoragePage<DeliverableSettingConfiguration> { PageNumber = number };
            for (var i = 0; i < rows; i++)
            {
                page.Rows.Add(new DeliverableSettingConfiguration());
            }

            return page;
        }

        [TestMethod]
        public async Task GetLatestPage_ReturnsOk()
        {
            _repository.Setup(r => r.GetEntitiesForLatestPage()).ReturnsAsync(Page(3, 1));

            Assert.IsInstanceOfType(await _controller.GetLatestPage(), typeof(OkObjectResult));
        }

        [TestMethod]
        public async Task GetPage_WithRows_ReturnsOkAndLinksNextAndPrevious()
        {
            _repository.Setup(r => r.GetEntitiesForPage(It.IsAny<int>())).ReturnsAsync(Page(4, 1));
            SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<DeliverableSettingConfiguration> captured = null;
            _generator
                .Setup(g => g.GenerateFeed(It.IsAny<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<DeliverableSettingConfiguration>>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ISyndicationItemCreator<DeliverableSettingConfiguration>>(), It.IsAny<bool>()))
                .Callback<SFA.FCT.ContractManagementService.AtomFeed.PageStorageResultSet<DeliverableSettingConfiguration>, string, string, string, ISyndicationItemCreator<DeliverableSettingConfiguration>, bool>((rs, a, b, c, d, e) => captured = rs)
                .Returns(new SyndicationFeed());

            var result = await _controller.GetPage(4);

            Assert.IsInstanceOfType(result, typeof(OkObjectResult));
            Assert.AreEqual(5, captured.NextPageNumber);
            Assert.AreEqual(3, captured.PrevPageNumber);
            Assert.AreEqual("notifications/changes", captured.RouteSuffix);
        }

        [TestMethod]
        public async Task GetPage_NoRows_ReturnsBadRequest()
        {
            _repository.Setup(r => r.GetEntitiesForPage(It.IsAny<int>())).ReturnsAsync(Page(1, 0));

            Assert.IsInstanceOfType(await _controller.GetPage(1), typeof(BadRequestResult));
        }
    }

    [TestClass, TestCategory("UnitTest")]
    public class ReferenceDataLookupApiControllerTests
    {
        private Mock<ICrmConfigurationRepository> _repository;
        private ReferenceDataLookupApiController _controller;

        [TestInitialize]
        public void Setup()
        {
            _repository = new Mock<ICrmConfigurationRepository>();
            _controller = new ReferenceDataLookupApiController(_repository.Object);
        }

        [TestMethod]
        public async Task GetLookupData_NoFundingStreamPeriod_ReturnsFundingConfiguration()
        {
            var expected = new FundingConfigurationType();
            _repository.Setup(r => r.GetFundingConfiguration("p", "pt", "ft")).ReturnsAsync(expected);

            var result = (OkObjectResult)await _controller.GetLookupData("p", "pt", "ft", null);

            Assert.AreSame(expected, result.Value);
        }

        [TestMethod]
        public async Task GetLookupData_WithFundingStreamPeriod_ReturnsDeliverableConfiguration()
        {
            var expected = new FSCDeliverableStructureDefinitionResponse();
            _repository.Setup(r => r.GetDeliverableConfiguration("FSP")).ReturnsAsync(expected);

            var result = (OkObjectResult)await _controller.GetLookupData(null, null, null, "FSP");

            Assert.AreSame(expected, result.Value);
        }

        [TestMethod]
        public async Task GetLookupData_RepositoryThrows_ReturnsBadRequestWithMessage()
        {
            _repository.Setup(r => r.GetDeliverableConfiguration(It.IsAny<string>())).ThrowsAsync(new InvalidOperationException("bad"));

            var result = (BadRequestObjectResult)await _controller.GetLookupData(null, null, null, "FSP");

            Assert.AreEqual("bad", result.Value);
        }
    }
}
