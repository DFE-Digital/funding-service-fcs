namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using System.Data.SqlClient;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using FluentAssertions;
    using FundingAllocation.Endpoints.ReleaseGroup;
    using FundingAllocation.Endpoints.ReleaseGroup.Handlers;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ReleaseGroupRepository = FundingAllocation.Endpoints.ReleaseGroup.Repositories.ReleaseGroupRepository;
    using IReleaseGroupRepository = FundingAllocation.Endpoints.ReleaseGroup.Repositories.IReleaseGroupRepository;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System.Collections.Generic;
    using FundingAllocation.Dto;
    using System.Linq;
    using System.Net.Http;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class FundingAllocationReleaseGroupHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseGroupHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<FundingAllocationReleaseGroupHandler>())
                .Register(Component.For<IHttpClientFactory>().Instance(Mock.Of<IHttpClientFactory>()));

            container.BeginScope();

            // act
            var handler = container.Resolve<FundingAllocationReleaseGroupHandler>();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingAllocationReleaseGroupHandler_Technical()
        {
            // arrange
            var context = new FundingAllocationContext(DbContextOptions);
            var appConfiguration = AppConfiguration.Configuration();
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), appConfiguration))
                .Register(Component.For<FundingAllocationContext>().Instance(context))
                .Register(Component.For<FundingAllocationReleaseGroupHandler>());

            container.BeginScope();

            // act
            var handler = container.Resolve<FundingAllocationReleaseGroupHandler>();
            handler.Handle(new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = new List<string> { "RG138297" },
                OnlyQueuedFundingAllocations = false

            }, new TestableMessageHandlerContext()).Wait();
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseGroupHandler_ShouldSendCreateContractForFundingAllocationContractGroupCommand_ForRevisedNew()
        {
            // arrange
            var fundingAllocationGroupingServiceMock = new Mock<IFundingAllocationGroupingService>();
            fundingAllocationGroupingServiceMock
                .Setup(m => m.GetFundingAllocationContractGroups(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(new List<FundingAllocationContractGroup>
                {
                    new FundingAllocationContractGroup(0, string.Empty, string.Empty, null, null)
                }.ToArray);

            var intentServiceMock = new Mock<IIntentService>();
            intentServiceMock
                .Setup(m => m.GetIntent(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), new List<ContractIdentity>(), new List<ContractAndStatus>(), It.IsAny<bool>()))
                .ReturnsAsync(new IntentResult(ContractIntent.RevisedNew, It.IsAny<CrmContractInfo>()));

            Mock<IReleaseGroupRepository> releaseGroupRepositoryMock = new Mock<IReleaseGroupRepository>();
            releaseGroupRepositoryMock.Setup(r => r.GetReleaseGroupInfos(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(new List<ReleaseGroupInfo>());
            releaseGroupRepositoryMock
                .Setup(r => r.GetReleaseGroupNameValidationResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(
                    new ReleaseGroupNameValidationResult(new List<string>(), new List<string>()));

            var handler = new FundingAllocationReleaseGroupHandler(
                Mock.Of<ILogger>(),
                fundingAllocationGroupingServiceMock.Object,
                releaseGroupRepositoryMock.Object,
                intentServiceMock.Object, 
                Mock.Of<IReleaseGroupFundingAllocationRepository>(),
                Mock.Of<ICrmFundingAllocationRepository>());

            var handlerContext = new TestableMessageHandlerContext();
            // act
            handler.Handle(new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = new List<string> {"test-rg"}
            }, handlerContext).Wait();

            // assert
            var sentCommands = handlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<CreateContractForFundingAllocationContractGroupCommand>()
                .ToList();

            sentCommands.Count.Should().Be(1);
            sentCommands[0].ContractIntent.Should().Be(ContractIntent.RevisedNew);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseGroupHandler_ShouldSendUpdateContractWithFundingAllocationsCommand_WithContractIntentUpdateDraftAmendment()
        {
            // arrange
            var fundingIds = new[]
            {
                "RG100001",
                "RG100002",
                "RG100003",
                "RG100004"
            };

            FundingAllocationContractGroup[] fundingAllocationContractGroups =
            {
                new FundingAllocationContractGroup(1, "", "", new List<string>(),
                    new ContractItemsMappingResult("", "", "", ""))
            };

            var existingCrmContract = new CrmContractInfo("123", 4, 5, 678, "CrmEntityId", "masterContractNumber", "Variation", new List<CrmAllocationInfo>(), 1);

            var fundingAllocationGroupingServiceMock = new Mock<IFundingAllocationGroupingService>();
            fundingAllocationGroupingServiceMock
                .Setup(m => m.GetFundingAllocationContractGroups(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(fundingAllocationContractGroups);

            Mock<IReleaseGroupRepository> releaseGroupRepositoryMock = new Mock<IReleaseGroupRepository>();
            releaseGroupRepositoryMock.Setup(r => r.GetReleaseGroupInfos(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(new List<ReleaseGroupInfo>());

            releaseGroupRepositoryMock
                .Setup(r => r.GetReleaseGroupNameValidationResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(
                    new ReleaseGroupNameValidationResult(new List<string>(), new List<string>()));

            var intentServiceMock = new Mock<IIntentService>();
            intentServiceMock
                .Setup(m => m.GetIntent(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), new List<ContractIdentity>(), new List<ContractAndStatus>(), It.IsAny<bool>()))
                .ReturnsAsync(new IntentResult(ContractIntent.UpdateDraftAmendment, existingCrmContract));

            var handler = new FundingAllocationReleaseGroupHandler(
                Mock.Of<ILogger>(),
                fundingAllocationGroupingServiceMock.Object,
                releaseGroupRepositoryMock.Object,
                intentServiceMock.Object, Mock.Of<IReleaseGroupFundingAllocationRepository>(),
                Mock.Of<ICrmFundingAllocationRepository>());

            var command = new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = fundingIds
            };

            var handlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, handlerContext).Wait();

            // assert
            var sentCommands = handlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<UpdateContractWithFundingAllocationsCommand>()
                .ToList();

            sentCommands.Count.Should().Be(1);
            sentCommands[0].ContractIntent.Should().Be(ContractIntent.UpdateDraftAmendment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseGroupHandler_ShouldSendUpdateContractWithFundingAllocationsCommand_WithContractIntentUpdateDraft()
        {
            // arrange
            var fundingIds = new[]
            {
                "RG100001",
                "RG100002",
                "RG100003",
                "RG100004"
            };

            FundingAllocationContractGroup[] fundingAllocationContractGroups =
            {
                new FundingAllocationContractGroup(1, "", "", new List<string>(),
                    new ContractItemsMappingResult("", "", "", ""))
            };

            var existingCrmContract = new CrmContractInfo("123", 4, 5, 678, "CrmEntityId", "masterContractNumber", "Variation", new List<CrmAllocationInfo>(), 1);

            var fundingAllocationGroupingServiceMock = new Mock<IFundingAllocationGroupingService>();
            fundingAllocationGroupingServiceMock
                .Setup(m => m.GetFundingAllocationContractGroups(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(fundingAllocationContractGroups);

            var intentServiceMock = new Mock<IIntentService>();
            intentServiceMock
                .Setup(m => m.GetIntent(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), new List<ContractIdentity>(), new List<ContractAndStatus>(), It.IsAny<bool>()))
                .ReturnsAsync(new IntentResult(ContractIntent.UpdateDraft, existingCrmContract));

            Mock<IReleaseGroupRepository> releaseGroupRepositoryMock = new Mock<IReleaseGroupRepository>();
            releaseGroupRepositoryMock.Setup(r => r.GetReleaseGroupInfos(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(new List<ReleaseGroupInfo>());

            releaseGroupRepositoryMock
                .Setup(r => r.GetReleaseGroupNameValidationResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(
                    new ReleaseGroupNameValidationResult(new List<string>(), new List<string>()));

            var handler = new FundingAllocationReleaseGroupHandler(
                Mock.Of<ILogger>(),
                fundingAllocationGroupingServiceMock.Object,
                releaseGroupRepositoryMock.Object,
                intentServiceMock.Object, 
                Mock.Of<IReleaseGroupFundingAllocationRepository>(),
                Mock.Of<ICrmFundingAllocationRepository>());

            var command = new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = fundingIds
            };

            var handlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, handlerContext).Wait();

            // assert
            var sentCommands = handlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<UpdateContractWithFundingAllocationsCommand>()
                .ToList();

            sentCommands.Count.Should().Be(1);
            sentCommands[0].ContractIntent.Should().Be(ContractIntent.UpdateDraft);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseGroupHandler_ShouldSendQueueFundingAllocationsGroupCommand_WhenDerivedIntentIsQueue()
        {
            // arrange
            var expectedContractItemsMappingResult = new ContractItemsMappingResult("", "", "", "");
            var expectedFundingIds = new List<string> { "FundingId1", "FundingId2", "FundingId3" };
            const string contractNumber = "CN - 1234";
            var crmContractInfo = new CrmContractInfo(contractNumber, 1, 0, 0, string.Empty, string.Empty, string.Empty, null, 0);

            FundingAllocationContractGroup[] fundingAllocationContractGroups =
            {
                new FundingAllocationContractGroup(1, "", "", expectedFundingIds, expectedContractItemsMappingResult)
            };

            var fundingAllocationGroupingServiceMock = new Mock<IFundingAllocationGroupingService>();
            fundingAllocationGroupingServiceMock
                .Setup(m => m.GetFundingAllocationContractGroups(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(fundingAllocationContractGroups);

            var intentServiceMock = new Mock<IIntentService>();
            intentServiceMock
                .Setup(m => m.GetIntent(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), new List<ContractIdentity>(), new List<ContractAndStatus>(), It.IsAny<bool>()))
                .ReturnsAsync(new IntentResult(ContractIntent.Queue, crmContractInfo));

            Mock<IReleaseGroupRepository> releaseGroupRepositoryMock = new Mock<IReleaseGroupRepository>();
            releaseGroupRepositoryMock.Setup(r => r.GetReleaseGroupInfos(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(new List<ReleaseGroupInfo>());

            releaseGroupRepositoryMock
                .Setup(r => r.GetReleaseGroupNameValidationResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(
                    new ReleaseGroupNameValidationResult(new List<string>(), new List<string>()));

            var handler = new FundingAllocationReleaseGroupHandler(
                Mock.Of<ILogger>(),
                fundingAllocationGroupingServiceMock.Object,
                releaseGroupRepositoryMock.Object,
                intentServiceMock.Object, 
                Mock.Of<IReleaseGroupFundingAllocationRepository>(),
                Mock.Of<ICrmFundingAllocationRepository>());

            var command = new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = new[] { string.Empty }
            };

            var handlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, handlerContext).Wait();

            // assert
            var sentCommands = handlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<QueueFundingAllocationsGroupCommand>()
                .ToList();

            sentCommands.Count.Should().Be(1);
            sentCommands[0].CrmContractInfo.Should().NotBeNull();
            sentCommands[0].CrmContractInfo.Number.Should().Be(contractNumber);
            sentCommands[0].FundingAllocationIds.Should().BeEquivalentTo(expectedFundingIds);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseGroupHandler_ShouldPublishFundingAllocationReleaseInProgressEvents()
        {
            // arrange
            const int releaseGroupIdOne = 1;
            const int releaseGroupIdTwo = 2;
            const string fundingTypeCode = "EDSK";
            const string fundingPeriodCode = "AY2122";
            const int releaseGroupGroupId = 3;

            var intentServiceMock = new Mock<IIntentService>();
            intentServiceMock
                .Setup(m => m.GetIntent(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), null, new List<ContractAndStatus>(), It.IsAny<bool>()))
                .ReturnsAsync(new IntentResult(ContractIntent.Queue, null));

            Mock<IReleaseGroupRepository> releaseGroupRepositoryMock = new Mock<IReleaseGroupRepository>();
            releaseGroupRepositoryMock.Setup(r => r.GetReleaseGroupInfos(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(new List<ReleaseGroupInfo>
                {
                    new ReleaseGroupInfo(releaseGroupIdOne, fundingTypeCode, fundingPeriodCode),
                    new ReleaseGroupInfo(releaseGroupIdTwo, fundingTypeCode, fundingPeriodCode),
                });

            releaseGroupRepositoryMock
                .Setup(r => r.GetReleaseGroupNameValidationResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(
                    new ReleaseGroupNameValidationResult(new List<string>(), new List<string>()));

            releaseGroupRepositoryMock.Setup(r => r.GetNextReleaseGroupGroupId()).ReturnsAsync(releaseGroupGroupId);

            var handler = new FundingAllocationReleaseGroupHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IFundingAllocationGroupingService>(),
                releaseGroupRepositoryMock.Object,
                intentServiceMock.Object, 
                Mock.Of<IReleaseGroupFundingAllocationRepository>(),
                Mock.Of<ICrmFundingAllocationRepository>());

            var command = new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = new[] { string.Empty }
            };

            var handlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, handlerContext).Wait();

            // assert
            var expectedAllocationReleaseInProgressEvents = new List<FundingAllocationReleaseInProgressEvent>
            {
                new FundingAllocationReleaseInProgressEvent(fundingTypeCode, fundingPeriodCode, releaseGroupGroupId)
            };

            var publishedMessages = handlerContext.PublishedMessages
                .Select(m => m.Message)
                .OfType<FundingAllocationReleaseInProgressEvent>()
                .ToList();

            publishedMessages.Count.Should().Be(expectedAllocationReleaseInProgressEvents.Count);
            publishedMessages.Should().BeEquivalentTo(expectedAllocationReleaseInProgressEvents);
        }
    }
}
