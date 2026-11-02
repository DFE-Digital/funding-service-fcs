namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Handlers
{
    using System;
    using System.Collections.Generic;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers;
    using SFA.FCT.CrossDomain.Integration.Events;
    using NServiceBus.Testing;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    [TestClass]
    public class ContractApprovedEventHandlerUnitTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedEventHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IPerformanceManagementDbContext>().ImplementedBy<PerformanceManagementDbContext>().LifestyleScoped().IsDefault())
                .Register(Component.For<ContractApprovedEventHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<ContractApprovedEventHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedEventHandler_ShouldSendExpectedNumberOfRecalculateFundingClaimReconciliationCommandsWhenRecalculationServiceReturnsResults()
        {
            // Arrange 
            IReadOnlyCollection<string> fspCodes = new List<string> {"X_FSPC", "Y_FSPC" };
            IReadOnlyCollection<AllocationInfo> allocationsPlannedValue = new List<AllocationInfo>
            {
                new AllocationInfo("X", 10),
                new AllocationInfo("Y", 20)
            };
            
            var fundingStreamPeriodQueryRepositoryMock = new Mock<IFundingStreamPeriodQueryRepository>();
            fundingStreamPeriodQueryRepositoryMock
                .Setup(m => m.GetPayOnProfileFundingStreamPeriodCodes(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(fspCodes);

            var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();
            fcrRecalculationRequiredCheckerMock
                .Setup(m => m.CheckIfRecalculationRequired(It.IsAny<IReadOnlyCollection<AllocationInfo>>(), It.IsAny<string>(), It.IsAny<decimal>()))
                .Returns(CreateRecalculationCheckResult);
            
            var contractAllocationRepositoryMock = new Mock<IContractAllocationRepository>();
            contractAllocationRepositoryMock
                .Setup(m => m.GetAllocationsWithPlannedValue(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(allocationsPlannedValue);
            
            var contractApprovedEventHandler = new ContractApprovedEventHandler(
                Mock.Of<ILogger>(),
                contractAllocationRepositoryMock.Object,
                fundingStreamPeriodQueryRepositoryMock.Object,
                Mock.Of<IContractAllocationDeliverableRepository>(),
                fcrRecalculationRequiredCheckerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            contractApprovedEventHandler.Handle(new ContractApprovedEvent
            {
                CorporateContract = new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ContractApprovalDate = DateTime.UtcNow,
                            contractAllocations = new List<contractAllocationsContractAllocation>
                            {
                                new ExtendedContractAllocation
                                {
                                    fundingStreamPeriodCode = "X_FSPC",
                                    contractAllocationNumber = "X"
                                },
                                new ExtendedContractAllocation
                                {
                                    fundingStreamPeriodCode = "Y_FSPC",
                                    contractAllocationNumber = "Y"
                                }
                            },
                            contractVersionNumber = 2
                        }
                    }
                }
            }, testableContext).Wait();

            // Assert
            Assert.AreEqual(2, testableContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableContext.SentMessages[0].Message is RecalculateFundingClaimReconciliationCommand,
                "The sent message is the wrong type");

            var sentMessage = testableContext.SentMessages[0].Message as RecalculateFundingClaimReconciliationCommand;
            Assert.AreEqual(10, sentMessage.CappedClaimAdjustment, "Incorrect CappedClaimAdjustment value returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedEventHandler_ShouldSendOneRecalculateFundingClaimReconciliationCommandsWhenTheirAreDuplicateFcrCrmIdsFromRecalculationCheckResult()
        {
            // Arrange 
            IReadOnlyCollection<string> fspCodes = new List<string> { "X_FSPC", "Y_FSPC" };
            IReadOnlyCollection<AllocationInfo> allocationsPlannedValue = new List<AllocationInfo>{
                new AllocationInfo("X", 10),
                new AllocationInfo("Y", 20)
            };

            var fundingStreamPeriodQueryRepositoryMock = new Mock<IFundingStreamPeriodQueryRepository>();
            fundingStreamPeriodQueryRepositoryMock
                .Setup(m => m.GetPayOnProfileFundingStreamPeriodCodes(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(fspCodes);

            Guid duplicateFcrCrmId = Guid.NewGuid();

            var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();
            fcrRecalculationRequiredCheckerMock
                .Setup(m => m.CheckIfRecalculationRequired(It.IsAny<IReadOnlyCollection<AllocationInfo>>(), It.IsAny<string>(), It.IsAny<decimal>()))
                .Returns(() => CreateRecalculationCheckResult(duplicateFcrCrmId));

            var contractAllocationRepositoryMock = new Mock<IContractAllocationRepository>();
            contractAllocationRepositoryMock
                .Setup(m => m.GetAllocationsWithPlannedValue(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(allocationsPlannedValue);

            var contractApprovedEventHandler = new ContractApprovedEventHandler(
                Mock.Of<ILogger>(),
                contractAllocationRepositoryMock.Object,
                fundingStreamPeriodQueryRepositoryMock.Object,
                Mock.Of<IContractAllocationDeliverableRepository>(),
                fcrRecalculationRequiredCheckerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            contractApprovedEventHandler.Handle(new ContractApprovedEvent
            {
                CorporateContract = new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ContractApprovalDate = DateTime.UtcNow,
                            contractAllocations = new List<contractAllocationsContractAllocation>
                            {
                                new ExtendedContractAllocation
                                {
                                    fundingStreamPeriodCode = "X_FSPC",
                                    contractAllocationNumber = "X"
                                },
                                new ExtendedContractAllocation
                                {
                                    fundingStreamPeriodCode = "Y_FSPC",
                                    contractAllocationNumber = "Y"
                                }
                            },
                            contractVersionNumber = 2
                        }
                    }
                }
            }, testableContext).Wait();

            // Assert
            Assert.AreEqual(1, testableContext.SentMessages.Length, "The wrong number of messages were sent");
            Assert.IsTrue(testableContext.SentMessages[0].Message is RecalculateFundingClaimReconciliationCommand,
                "The sent message is the wrong type");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedEventHandler_ShouldNotSendRecalculateFundingClaimReconciliationCommandsWhenContractIsNew()
        {
            // Arrange 
            IReadOnlyCollection<string> fspCodes = new List<string> { "X_FSPC" };
            IReadOnlyCollection<AllocationInfo> allocationsPlannedValue = new List<AllocationInfo>{ new AllocationInfo("X", 10) };

            var fundingStreamPeriodQueryRepositoryMock = new Mock<IFundingStreamPeriodQueryRepository>();
            fundingStreamPeriodQueryRepositoryMock
                .Setup(m => m.GetPayOnProfileFundingStreamPeriodCodes(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(fspCodes);

            var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();
            fcrRecalculationRequiredCheckerMock
                .Setup(m => m.CheckIfRecalculationRequired(It.IsAny<IReadOnlyCollection<AllocationInfo>>(), It.IsAny<string>(), It.IsAny<decimal>()))
                .Returns(CreateRecalculationCheckResult);

            var contractAllocationRepositoryMock = new Mock<IContractAllocationRepository>();
            contractAllocationRepositoryMock
                .Setup(m => m.GetAllocationsWithPlannedValue(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(allocationsPlannedValue);

            var contractApprovedEventHandler = new ContractApprovedEventHandler(
                Mock.Of<ILogger>(),
                contractAllocationRepositoryMock.Object,
                fundingStreamPeriodQueryRepositoryMock.Object,
                Mock.Of<IContractAllocationDeliverableRepository>(),
                fcrRecalculationRequiredCheckerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            contractApprovedEventHandler.Handle(new ContractApprovedEvent
            {
                CorporateContract = new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ContractApprovalDate = DateTime.UtcNow,
                            contractAllocations = new List<contractAllocationsContractAllocation>
                            {
                                new ExtendedContractAllocation
                                {
                                    fundingStreamPeriodCode = "X_FSPC",
                                    contractAllocationNumber = "X"
                                }
                            },
                            contractVersionNumber = 1
                        }
                    }
                }
            }, testableContext).Wait();

            // Assert
            Assert.AreEqual(0, testableContext.SentMessages.Length, "The wrong number of messages were sent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedEventHandler_ShouldNotSendRecalculateFundingClaimReconciliationCommandsWhenRecalculationServiceReturnsNoResults()
        {
            // Arrange 
            IReadOnlyCollection<string> fspCodes = new List<string> { "X_FSPC" };
            IReadOnlyCollection<AllocationInfo> allocationsPlannedValue = new List<AllocationInfo>{ new AllocationInfo("X", 10) };

            var fundingStreamPeriodQueryRepositoryMock = new Mock<IFundingStreamPeriodQueryRepository>();
            fundingStreamPeriodQueryRepositoryMock
                .Setup(m => m.GetPayOnProfileFundingStreamPeriodCodes(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(fspCodes);

            var fcrRecalculationRequiredCheckerMock = new Mock<IFcrRecalculationRequiredChecker>();
            fcrRecalculationRequiredCheckerMock
                .Setup(m => m.CheckIfRecalculationRequired(It.IsAny<IReadOnlyCollection<AllocationInfo>>(), It.IsAny<string>(), It.IsAny<decimal>()))
                .Returns(new RecalculationCheckResult(false, new FundingClaimReconciliationInformation(true, string.Empty, string.Empty, string.Empty, string.Empty, 1, string.Empty, Guid.NewGuid(), 0)));

            var contractAllocationRepositoryMock = new Mock<IContractAllocationRepository>();
            contractAllocationRepositoryMock
                .Setup(m => m.GetAllocationsWithPlannedValue(It.IsAny<List<string>>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(allocationsPlannedValue);

            var contractApprovedEventHandler = new ContractApprovedEventHandler(
                Mock.Of<ILogger>(),
                contractAllocationRepositoryMock.Object,
                fundingStreamPeriodQueryRepositoryMock.Object,
                Mock.Of<IContractAllocationDeliverableRepository>(),
                fcrRecalculationRequiredCheckerMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            TestableMessageHandlerContext testableContext = new TestableMessageHandlerContext();

            // Act
            contractApprovedEventHandler.Handle(new ContractApprovedEvent
            {
                CorporateContract = new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ContractApprovalDate = DateTime.UtcNow,
                            contractAllocations = new List<contractAllocationsContractAllocation>
                            {
                                new ExtendedContractAllocation
                                {
                                    fundingStreamPeriodCode = "X_FSPC",
                                    contractAllocationNumber = "X"
                                }
                            },
                            contractVersionNumber = 2
                        }
                    }
                }
            }, testableContext).Wait();

            // Assert
            Assert.AreEqual(0, testableContext.SentMessages.Length, "The wrong number of messages were sent");
        }

        private RecalculationCheckResult CreateRecalculationCheckResult()
        {
            return new RecalculationCheckResult(true, new FundingClaimReconciliationInformation(true, string.Empty, string.Empty, string.Empty, string.Empty, 1, string.Empty, Guid.NewGuid(), 10));
        }

        private RecalculationCheckResult CreateRecalculationCheckResult(Guid fcrGuid)
        {
            return new RecalculationCheckResult(true, new FundingClaimReconciliationInformation(true, string.Empty, string.Empty, string.Empty, string.Empty, 1, string.Empty, fcrGuid, 0));
        }
    }
}