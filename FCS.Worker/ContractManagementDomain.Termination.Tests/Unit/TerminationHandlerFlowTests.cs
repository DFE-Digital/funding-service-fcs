namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.DTOs;
    using ContractManagementDomain.Termination.Handlers;
    using ContractManagementDomain.Termination.Infrastructure;
    using ContractManagementDomain.Termination.Repositories;
    using ContractManagementDomain.Termination.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.ContractManagementService.Common.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class TerminationHandlerFlowTests
    {
        private const string ContractNumber = "CON-1";
        private const int VersionNumber = 2;
        private const int SubVersionNumber = 3;

        private readonly Mock<ISessionConnectionFactory> _connectionFactory = new Mock<ISessionConnectionFactory>();
        private readonly Mock<ITerminateContractFeedService> _feedService = new Mock<ITerminateContractFeedService>();
        private readonly TestableMessageHandlerContext _context = new TestableMessageHandlerContext();

        private Action<contract> _capturedUpdate;
        private AtomItemType _capturedItemType;

        private static contract CreateContract()
        {
            return new contract
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractStatus = new contractStatusType { parentStatus = "Approved", status = "Approved" },
                        TerminationDate = new DateTime(2020, 1, 1),
                        TerminationReason = "reason",
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = "ALLOC-1",
                                StopNewStartsDate = new DateTime(2020, 2, 2),
                                FundingCessationDate = new DateTime(2020, 3, 3),
                                NewStartsSuspendedReason = "suspended",
                                InflightStopNewStartsDate = new DateTime(2020, 4, 4),
                                InflightNewStartsSuspendedReason = "inflight"
                            },
                            new contractAllocationsContractAllocation { contractAllocationNumber = "ALLOC-2" }
                        }
                    }
                }
            };
        }

        private void SetupFeedService(AtomItemCreationResult result, contract corporateContract)
        {
            _ = _feedService
                .Setup(f => f.UpdateContractAndAddToFeed(It.IsAny<ConnectionInfo>(), It.IsAny<ContractIdentifier>(), It.IsAny<Action<contract>>(), It.IsAny<string>(), It.IsAny<AtomItemType>()))
                .Returns(new UpdateSubStatusAndAddContractToFeedResult(result, corporateContract))
                .Callback<ConnectionInfo, ContractIdentifier, Action<contract>, string, AtomItemType>((c, i, update, m, type) =>
                {
                    _capturedUpdate = update;
                    _capturedItemType = type;
                });
        }

        private void AssertCrmCommandSent(SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse expected)
        {
            var sent = _context.SentMessages.Select(m => m.Message).OfType<SetContractTerminationToCompleteInCrmCommand>().Single();
            Assert.AreEqual(ContractNumber, sent.ContractNumber);
            Assert.AreEqual(VersionNumber, sent.VersionNumber);
            Assert.AreEqual(SubVersionNumber, sent.SubVersionNumber);
            Assert.AreEqual(expected, sent.RequiredCrmServiceResponse);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ApproveContractModification_WhenFeedItemAdded_SendsCrmAndReleaseCommands()
        {
            SetupFeedService(AtomItemCreationResult.Added, CreateContract());
            var handler = new ApproveContractModificationHandler(Mock.Of<ILogger>(), _connectionFactory.Object, _feedService.Object);

            await handler.Handle(
                new ApproveContractModificationCommand { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber },
                _context);

            Assert.AreEqual(AtomItemType.ContractModified, _capturedItemType);
            AssertCrmCommandSent(SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.ModificationSuccessful);
            var release = _context.SentMessages.Select(m => m.Message).OfType<ReleaseQueuedFundingAllocationsForContractsCommand>().Single();
            Assert.IsTrue(release.IgnoreContractIdentitiesWhenConsideringIntent);
            Assert.AreEqual(2, _context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ApproveContractModification_WhenFeedItemAlreadyPresentWithSameId_SendsNothing()
        {
            SetupFeedService(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, CreateContract());
            var handler = new ApproveContractModificationHandler(Mock.Of<ILogger>(), _connectionFactory.Object, _feedService.Object);

            await handler.Handle(new ApproveContractModificationCommand { ContractNumber = ContractNumber }, _context);

            Assert.AreEqual(0, _context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task ApproveContractModification_UpdateCallback_SetsChildStatusToModified()
        {
            SetupFeedService(AtomItemCreationResult.AlreadyPresent, CreateContract());
            var handler = new ApproveContractModificationHandler(Mock.Of<ILogger>(), _connectionFactory.Object, _feedService.Object);
            await handler.Handle(new ApproveContractModificationCommand { ContractNumber = ContractNumber }, _context);
            var corporateContract = CreateContract();

            _capturedUpdate(corporateContract);

            Assert.AreEqual("Modified", corporateContract.contracts[0].contractStatus.status);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task CancelContractModification_WhenFeedItemAdded_SendsCrmCommand()
        {
            SetupFeedService(AtomItemCreationResult.Added, CreateContract());
            var handler = new CancelContractModificationHandler(Mock.Of<ILogger>(), _connectionFactory.Object, _feedService.Object);

            await handler.Handle(
                new CancelContractModificationCommand { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber },
                _context);

            Assert.AreEqual(AtomItemType.ContractModificationCancelled, _capturedItemType);
            AssertCrmCommandSent(SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.ModificationCancellationSuccessful);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task CancelContractModification_WhenFeedItemAlreadyPresentWithSameId_SendsNothing()
        {
            SetupFeedService(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, CreateContract());
            var handler = new CancelContractModificationHandler(Mock.Of<ILogger>(), _connectionFactory.Object, _feedService.Object);

            await handler.Handle(new CancelContractModificationCommand { ContractNumber = ContractNumber }, _context);

            Assert.AreEqual(0, _context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task CancelContractModification_UpdateCallback_ResetsStatusAndClearsModificationValues()
        {
            SetupFeedService(AtomItemCreationResult.Added, CreateContract());
            var handler = new CancelContractModificationHandler(Mock.Of<ILogger>(), _connectionFactory.Object, _feedService.Object);
            await handler.Handle(new CancelContractModificationCommand { ContractNumber = ContractNumber }, _context);
            var corporateContract = CreateContract();
            corporateContract.contracts[0].contractStatus.status = "Modified";

            _capturedUpdate(corporateContract);

            var allocation = corporateContract.contracts[0].contractAllocations[0];
            Assert.AreEqual("Approved", corporateContract.contracts[0].contractStatus.status);
            Assert.IsNull(allocation.StopNewStartsDate);
            Assert.IsNull(allocation.NewStartsSuspendedReason);
            Assert.IsNull(allocation.InflightStopNewStartsDate);
            Assert.IsNull(allocation.InflightNewStartsSuspendedReason);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task UpdateContractModification_WhenFeedItemAdded_SendsCrmCommand()
        {
            SetupFeedService(AtomItemCreationResult.Added, CreateContract());
            var handler = new UpdateContractModificationHandler(Mock.Of<ILogger>(), _connectionFactory.Object, _feedService.Object);

            await handler.Handle(
                new UpdateContractModificationCommand { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber },
                _context);

            Assert.AreEqual(AtomItemType.TerminationModificationDetailsUpdated, _capturedItemType);
            AssertCrmCommandSent(SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.ModificationDetailsUpdateSuccessful);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task UpdateContractModification_WhenFeedItemAlreadyPresentWithSameId_SendsNothingAndCallbackSetsModified()
        {
            SetupFeedService(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId, CreateContract());
            var handler = new UpdateContractModificationHandler(Mock.Of<ILogger>(), _connectionFactory.Object, _feedService.Object);
            await handler.Handle(new UpdateContractModificationCommand { ContractNumber = ContractNumber }, _context);
            var corporateContract = CreateContract();

            _capturedUpdate(corporateContract);

            Assert.AreEqual(0, _context.SentMessages.Length);
            Assert.AreEqual("Modified", corporateContract.contracts[0].contractStatus.status);
        }

        private CancelContractTerminationHandler CreateCancelTerminationHandler(
            Mock<IApprovalOnwardsContractAtomFeedService> feed, contract corporateContract)
        {
            var contractService = new Mock<ICorporateContractService>();
            _ = contractService
                .Setup(s => s.GetContract(It.IsAny<ConnectionInfo>(), It.IsAny<ICrmContractRepository>(), It.IsAny<IContractsManager>(), It.IsAny<ILegalDeliverableService>(), It.IsAny<ContractIdentifier>()))
                .Returns(corporateContract);

            return new CancelContractTerminationHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ICrmContractRepository>(),
                Mock.Of<IContractsManager>(),
                Mock.Of<ILegalDeliverableService>(),
                feed.Object,
                _connectionFactory.Object,
                contractService.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task CancelContractTermination_WhenFeedItemAdded_ClearsTerminationAndPublishesCancelledEvent()
        {
            var corporateContract = CreateContract();
            var feed = new Mock<IApprovalOnwardsContractAtomFeedService>();
            _ = feed.Setup(f => f.AddContractToFeed(It.IsAny<ConnectionInfo>(), corporateContract, It.IsAny<Guid>(), AtomItemType.CancelledContractTermination))
                .Returns(AtomItemCreationResult.Added);
            var handler = CreateCancelTerminationHandler(feed, corporateContract);

            await handler.Handle(
                new CancelContractTerminationCommand { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber },
                _context);

            var published = (ContractTerminationCancelledEvent)_context.PublishedMessages.Single().Message;
            Assert.AreEqual(ContractNumber, published.ContractNumber);
            Assert.AreEqual(VersionNumber, published.VersionNumber);
            Assert.AreEqual(SubVersionNumber, published.SubVersionNumber);
            CollectionAssert.AreEqual(new[] { "ALLOC-1", "ALLOC-2" }, published.AllocationNumbers.ToArray());
            var child = corporateContract.contracts[0];
            Assert.IsNull(child.TerminationDate);
            Assert.IsNull(child.TerminationReason);
            Assert.IsNull(child.contractAllocations[0].FundingCessationDate);
            Assert.IsNull(child.contractAllocations[0].StopNewStartsDate);
            Assert.AreEqual("Approved", child.contractStatus.status);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task CancelContractTermination_WhenFeedItemAlreadyPresentWithSameId_PublishesNothing()
        {
            var corporateContract = CreateContract();
            var feed = new Mock<IApprovalOnwardsContractAtomFeedService>();
            _ = feed.Setup(f => f.AddContractToFeed(It.IsAny<ConnectionInfo>(), It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<AtomItemType>()))
                .Returns(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId);
            var handler = CreateCancelTerminationHandler(feed, corporateContract);

            await handler.Handle(new CancelContractTerminationCommand { ContractNumber = ContractNumber }, _context);

            Assert.AreEqual(0, _context.PublishedMessages.Length);
        }

        private TerminateContractHandler CreateTerminateHandler(
            Either<RejectionReason, TerminateContractInfo> validation, Mock<IApprovalOnwardsContractAtomFeedService> feed, contract corporateContract)
        {
            var infoCreator = new Mock<ITerminateContractInfoCreator>();
            _ = infoCreator.Setup(c => c.CreateTerminateContractInfo(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns(new TerminateContractInfo(false, DateTime.Now, new ContractIdentifier(ContractNumber, VersionNumber, SubVersionNumber), null, null, DateTime.Now));
            var validationService = new Mock<ITerminateContractValidationService>();
            _ = validationService.Setup(v => v.Validate(It.IsAny<TerminateContractInfo>())).Returns(validation);
            var contractService = new Mock<ICorporateContractService>();
            _ = contractService
                .Setup(s => s.GetContract(It.IsAny<ConnectionInfo>(), It.IsAny<ICrmContractRepository>(), It.IsAny<IContractsManager>(), It.IsAny<ILegalDeliverableService>(), It.IsAny<ContractIdentifier>()))
                .Returns(corporateContract);

            return new TerminateContractHandler(
                Mock.Of<ILogger>(),
                infoCreator.Object,
                validationService.Object,
                _connectionFactory.Object,
                Mock.Of<ICrmContractRepository>(),
                Mock.Of<IContractsManager>(),
                Mock.Of<ILegalDeliverableService>(),
                feed.Object,
                contractService.Object);
        }

        private static Either<RejectionReason, TerminateContractInfo> ValidInfo(DateTime terminationDate)
        {
            return new Either<RejectionReason, TerminateContractInfo>(
                new TerminateContractInfo(false, terminationDate, new ContractIdentifier(ContractNumber, VersionNumber, SubVersionNumber), null, null, DateTime.Now));
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task TerminateContract_WhenValidAndFeedItemAdded_ClosesContractAndPublishesTerminatedEvent()
        {
            var terminationDate = new DateTime(2021, 5, 5);
            var corporateContract = CreateContract();
            corporateContract.contracts[0].endDate = null;
            var feed = new Mock<IApprovalOnwardsContractAtomFeedService>();
            _ = feed.Setup(f => f.AddContractToFeed(It.IsAny<ConnectionInfo>(), corporateContract, It.IsAny<Guid>(), AtomItemType.ContractTerminated))
                .Returns(AtomItemCreationResult.Added);
            var handler = CreateTerminateHandler(ValidInfo(terminationDate), feed, corporateContract);

            await handler.Handle(
                new TerminateContractCommand { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber },
                _context);

            var published = (ContractTerminatedEvent)_context.PublishedMessages.Single().Message;
            Assert.AreEqual(ContractNumber, published.ContractNumber);
            CollectionAssert.AreEqual(new[] { "ALLOC-1", "ALLOC-2" }, published.AllocationNumbers.ToArray());
            var child = corporateContract.contracts[0];
            Assert.AreEqual("Closed", child.contractStatus.parentStatus);
            Assert.AreEqual("Terminated", child.contractStatus.status);
            Assert.AreEqual(terminationDate, child.endDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task TerminateContract_WhenValidAndFeedItemAlreadyPresentWithSameId_PublishesNothing()
        {
            var feed = new Mock<IApprovalOnwardsContractAtomFeedService>();
            _ = feed.Setup(f => f.AddContractToFeed(It.IsAny<ConnectionInfo>(), It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<AtomItemType>()))
                .Returns(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId);
            var handler = CreateTerminateHandler(ValidInfo(DateTime.Now), feed, CreateContract());

            await handler.Handle(new TerminateContractCommand { ContractNumber = ContractNumber }, _context);

            Assert.AreEqual(0, _context.PublishedMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task TerminateContract_WhenValidationFails_PublishesFailedEventWithReason()
        {
            var rejection = new Either<RejectionReason, TerminateContractInfo>(
                new RejectionReason("Termination date must be in the past", RejectionReason.Why.TerminationDateIsNotValid));
            var feed = new Mock<IApprovalOnwardsContractAtomFeedService>();
            var handler = CreateTerminateHandler(rejection, feed, CreateContract());

            await handler.Handle(
                new TerminateContractCommand { ContractNumber = ContractNumber, VersionNumber = VersionNumber, SubVersionNumber = SubVersionNumber },
                _context);

            var published = (ContractTerminationFailedEvent)_context.PublishedMessages.Single().Message;
            Assert.AreEqual("Termination date must be in the past", published.FailureReason);
            Assert.AreEqual(SubVersionNumber, published.SubVersionNumber);
            feed.Verify(f => f.AddContractToFeed(It.IsAny<ConnectionInfo>(), It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<AtomItemType>()), Times.Never());
        }
    }
}
