namespace ContractManagementDomain.Endpoint.Tests.ContractClosure
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using Endpoint.ContractClosure;
    using Endpoint.ContractClosure.Services;
    using Endpoint.Repositories;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ApproveContractClosureHandlerTests
    {
        private Mock<IApprovalOnwardsContractAtomFeedService> _mockCreationService;
        private Mock<IContractsManager> _mockContractsManager;
        private IReadOnlyCollection<string> _allocationNumbersReturned;
        private Mock<IValidationService> _mockValidationService;
        private Mock<IDateProvider> _mockIDate;
        private Mock<IApprovedContractRepository> _mockApprovedContractRepository;
        private Mock<IApprovedContractAllocationRepository> _mockApprovedContractAllocationRepository;
        private Mock<ICrmContractRepository> _mockCrmContractRepository;
        private TestableMessageHandlerContext _messageHandlerContext;
        private DateTime _dateTimeReturnedFromMock;
        private ApproveContractClosureHandler _handler;
        private ApproveContractClosureCommand _dummyCommand;

        private void Setup()
        {
            _mockCreationService = new Mock<IApprovalOnwardsContractAtomFeedService>();
            _mockCreationService
                .Setup(m => m.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .Returns(AtomItemCreationResult.Added);

            _mockContractsManager = new Mock<IContractsManager>();
            _mockContractsManager
                .Setup(m => m.GetCorporateContractForSpecificVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractStatus = new contractStatusType
                            {
                                status = "ClosureInProgess"
                            }
                        }
                    }
                });

            _allocationNumbersReturned = new[] { "Allocation1", "Allocation2" };

            _mockValidationService = new Mock<IValidationService>();
            _mockValidationService
                .Setup(m => m.GetFirstFailureMessageForApproveContractClosure(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns((string)null);

            _dateTimeReturnedFromMock = new DateTime(2018, 1, 1, 15, 50, 20);
            _mockIDate = new Mock<IDateProvider>();
            _mockIDate
                .Setup(m => m.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(_dateTimeReturnedFromMock);

            _mockApprovedContractRepository = new Mock<IApprovedContractRepository>();
            _mockApprovedContractRepository
                .Setup(m => m.GetFundingTypeFundingPeriodForContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FundingTypeFundingPeriod
                {
                    AreContractsOpenEnded = true
                });

            _mockApprovedContractAllocationRepository = new Mock<IApprovedContractAllocationRepository>();
            _mockApprovedContractAllocationRepository
                .Setup(m => m.GetAllocationNumbersForApprovedContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(_allocationNumbersReturned);

            _mockCrmContractRepository = new Mock<ICrmContractRepository>();

            _messageHandlerContext = new TestableMessageHandlerContext();

            _handler = new ApproveContractClosureHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                _mockApprovedContractRepository.Object,
                _mockApprovedContractAllocationRepository.Object,
                _mockValidationService.Object,
                _mockIDate.Object,
                _mockCrmContractRepository.Object,
                _mockContractsManager.Object,
                _mockCreationService.Object,
                Mock.Of<ILegalDeliverableService>()
                );

            _dummyCommand = new ApproveContractClosureCommand
            {
                ContractNumber = "test-contract",
                VersionNumber = 1,
                SubVersionNumber = 1
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container =
                new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault())
                .Register(Component.For<ApproveContractClosureHandler>());

            container.BeginScope();

            // act
            container.Resolve<ApproveContractClosureHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_WhenRequestIsDeemedValidByValidationService_ShouldPublishExpectedEventWithExpectedValues()
        {
            // Arrange
            Setup();

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.AreEqual(1, _messageHandlerContext.PublishedMessages
                .Select(pm => pm.Message)
                .OfType<ContractClosedEvent>()
                .Count());
            Assert.IsFalse(_messageHandlerContext.SentMessages.Any());
            _mockCrmContractRepository.Verify(m => m.UpdateServiceResponseOnContract(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<sfa_serviceresponse>()), Times.Never);

            ContractClosedEvent publishedEvent = (ContractClosedEvent)_messageHandlerContext.PublishedMessages.Single().Message;

            Assert.AreEqual(_dummyCommand.ContractNumber, publishedEvent.ContractNumber, "Contract number incorrectly set on the event.");
            Assert.AreEqual(_dummyCommand.VersionNumber, publishedEvent.VersionNumber, "Version number was incorrectly set on the event.");
            Assert.AreEqual(_dummyCommand.SubVersionNumber, publishedEvent.SubVersionNumber, "Subversion number was incorrectly set on the event.");
            Assert.AreEqual(true, publishedEvent.IsContractOpenEnded, "IsContractOpenEnded was incorrectly set on the event");
            Assert.AreEqual(_dateTimeReturnedFromMock, publishedEvent.ClosureDate, "ClosureDate was incorrectly set on the event");
            Assert.AreEqual(_allocationNumbersReturned.Count, publishedEvent.AllocationNumbers.Count(), "Length of allocation numbers differed from expected");
            _allocationNumbersReturned.ForEach(anr =>
            {
                Assert.IsTrue(publishedEvent.AllocationNumbers.Contains(anr), $"Published event did not contain {anr} in the list of allocation numbers");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_WhenRequestIsDeemedInvalidByValidationService_ShouldPublishNotification()
        {
            // Arrange
            Setup();
            const string testNotificationText = "Something went wrong";

            _mockValidationService
                .Setup(m => m.GetFirstFailureMessageForApproveContractClosure(It.IsAny<ContractIdentifier>(), It.IsAny<ConnectionInfo>()))
                .Returns(testNotificationText);

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.IsFalse(_messageHandlerContext.PublishedMessages.Any(), "IContractClosedEvent was published on Bus unexpectedly");
            Assert.AreEqual(1, _messageHandlerContext.SentMessages
                .Select(sm => sm.Message)
                .OfType<IssueCrmNotificationCommand>()
                .Count(cmd =>
                    cmd.ContractNumber == _dummyCommand.ContractNumber &&
                    cmd.NotificationType == NotificationType.ApproveContractClosureFailed &&
                    cmd.VersionNumber == _dummyCommand.VersionNumber &&
                    cmd.SubVersionNumber == _dummyCommand.SubVersionNumber &&
                    cmd.NotificationText == testNotificationText));
            _mockCreationService.Verify(m => m.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()), Times.Never, "An attempt was made to add to atom feed unexpectedly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_WhenTheClosedContractHasBeenAddedPreviouslyToTheAtomFeed_ShouldNotPublishContractClosedEvent()
        {
            // Arrange
            Setup();
            _mockCreationService.Setup(m => m.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>())).Returns(AtomItemCreationResult.AlreadyPresent);

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.IsFalse(_messageHandlerContext.PublishedMessages.Any(), "IContractClosedEvent was unexpectedly published on bus");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_WhenResultOfAddingToAtomFeedIsAlreadyPresentWithSameFeedItemId_ShouldPublishContractClosedEvent()
        {
            // Arrange
            Setup();
            _mockCreationService.Setup(m => m.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>())).Returns(AtomItemCreationResult.AlreadyPresentWithSameFeedItemId);

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.AreEqual(1, _messageHandlerContext.PublishedMessages.Select(pm => pm.Message).OfType<ContractClosedEvent>().Count(), "IContractClosedEvent was not published on Bus when expected");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_ShouldStoreClosedContractInAtomFeed()
        {
            // Arrange
            Setup();

            contract contractPassedIn = null;
            _mockCreationService
                .Setup(s => s.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .Callback<contract, Guid, ConnectionInfo>(
                (c, g, ci) =>
                {
                    contractPassedIn = c;
                });

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.IsTrue(contractPassedIn.contracts.All(c => c.contractStatus.status == "Closed"), "The child contracts do not have a status of Closed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_WhenContractIsNotUnderTermination_ShouldStoreClosedContractInAtomFeedWithCombinedStatusOfClosedClosed()
        {
            // Arrange
            Setup();

            _mockContractsManager
                .Setup(m => m.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<bool>()))
                .Returns(new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractStatus = new contractStatusType
                            {
                                status = "ClosureInProgess"
                            },
                            TerminationReason = null
                        }
                    }
                });

            contract publishedContract = null;
            _mockCreationService
                .Setup(s => s.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .Callback<contract, Guid, ConnectionInfo>(
                (c, g, ci) =>
                {
                    publishedContract = c;
                });

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.AreEqual("Closed", publishedContract.contracts.Single().contractStatus.parentStatus, "The child contract does not have a parent status of Closed");
            Assert.AreEqual("Closed", publishedContract.contracts.Single().contractStatus.status, "The child contract does not have a sub status of Closed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_WhenContractIsUnderTermination_ShouldStoreClosedContractInAtomFeedWithCombinedStatusOfClosedUnderTermination()
        {
            // Arrange
            Setup();

            _mockContractsManager
                .Setup(m => m.GetCorporateContractForSpecificVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractStatus = new contractStatusType
                            {
                                status = "ClosureInProgess"
                            },
                            TerminationReason = "Termination Reason"
                        }
                    }
                });

            contract publishedContract = null;
            _mockCreationService
                .Setup(s => s.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .Callback<contract, Guid, ConnectionInfo>(
                (c, g, ci) =>
                {
                    publishedContract = c;
                });

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.AreEqual("Closed", publishedContract.contracts.Single().contractStatus.parentStatus, "The child contract does not have a parent status of Closed");
            Assert.AreEqual("Under Termination", publishedContract.contracts.Single().contractStatus.status, "The child contract does not have a sub status of Under Termination");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_WhenContractAndAllocationEndDatesAreNotEmpty_ShouldNotChangeEndDates()
        {
            DateTime contractEndDate = new DateTime(2020, 01, 01, 12, 0, 0, DateTimeKind.Utc);

            // Arrange
            Setup();

            _mockContractsManager
                .Setup(m => m.GetCorporateContractForSpecificVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractStatus = new contractStatusType
                            {
                                status = "ClosureInProgess",
                            },
                            contractAllocations = new List<contractAllocationsContractAllocation>
                            {
                                new contractAllocationsContractAllocation
                                {
                                    endDate = contractEndDate
                                }
                            },
                            endDate = contractEndDate
                        }
                    }
                });

            contract publishedContract = null;
            _mockCreationService
                .Setup(s => s.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .Callback<contract, Guid, ConnectionInfo>(
                (c, g, ci) =>
                {
                    publishedContract = c;
                });

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.AreEqual(contractEndDate, publishedContract.contracts.Single().endDate, "The child contract does not have the original end date");
            Assert.AreEqual(contractEndDate, publishedContract.contracts.Single().contractAllocations.Single().endDate, "The allocation does not have the original end date");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_WhenContractAndAllocationEndDatesAreEmpty_ShouldSetEndDatesToNow()
        {
            DateTime now = DateTime.UtcNow;

            // Arrange
            Setup();

            _mockContractsManager
                .Setup(m => m.GetCorporateContractForSpecificVersion(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns(new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractStatus = new contractStatusType
                            {
                                status = "ClosureInProgess"
                            },
                            contractAllocations = new List<contractAllocationsContractAllocation>
                            {
                                new contractAllocationsContractAllocation
                                {
                                    endDate = null
                                }
                            },
                            endDate = null
                        }
                    }
                });

            _mockIDate
                .Setup(m => m.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(now);

            contract publishedContract = null;
            _mockCreationService
                .Setup(s => s.AddClosedContract(It.IsAny<contract>(), It.IsAny<Guid>(), It.IsAny<ConnectionInfo>()))
                .Callback<contract, Guid, ConnectionInfo>(
                (c, g, ci) =>
                {
                    publishedContract = c;
                });

            // Act
            _handler.Handle(_dummyCommand, _messageHandlerContext).Wait();

            // Assert
            Assert.AreEqual(now, publishedContract.contracts.Single().endDate, "The child contract does not have an end date of now");
            Assert.AreEqual(now, publishedContract.contracts.Single().contractAllocations.Single().endDate, "The allocation does not have an end date of now");
        }
    }
}
